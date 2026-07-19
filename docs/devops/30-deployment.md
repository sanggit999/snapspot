# 30 - Deployment

Tài liệu này hướng dẫn các bước thiết lập máy chủ VPS (Ubuntu Server) và triển khai thực tế (Production Deployment) toàn bộ hệ thống SnapSpot.

---

## 1. Yêu cầu Cấu hình Máy chủ tối thiểu (Hardware Requirements)
- **Hệ điều hành**: Ubuntu 22.04 LTS (x64)
- **CPU**: Tối thiểu 2 Cores
- **RAM**: Tối thiểu 4GB (để chạy tốt Docker Stack gồm DB, Redis, Django và Celery)
- **Lưu trữ**: 40GB SSD hoặc cao hơn.

---

## 2. Thiết lập Môi trường hệ thống (Server Preparation)

Thực hiện cài đặt Docker và Docker Compose trên máy chủ Ubuntu:
```bash
# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce -y

# Thêm user vào nhóm docker để chạy không cần sudo
sudo usermod -aG docker ${USER}
```

---

## 3. Cấu hình Nginx làm Gateway và Tải SSL (Let's Encrypt)

Nginx được cài đặt trực tiếp trên hệ điều hành chính (Host OS) để điều phối lưu lượng truy cập vào Docker Container.

### 3.1. Cài đặt Nginx & Certbot SSL
```bash
sudo apt install nginx certbot python3-certbot-nginx -y
```

### 3.2. Cấu hình File Server Block của Nginx (`/etc/nginx/sites-available/snapspot`)
```nginx
server {
    listen 80;
    server_name api.snapspot.com;

    # Cấu hình chuyển hướng HTTP sang HTTPS tự động
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.snapspot.com;

    # Đường dẫn chứng chỉ SSL Let's Encrypt (Certbot tự sinh)
    ssl_certificate /etc/letsencrypt/live/api.snapspot.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.snapspot.com/privkey.pem;

    # Bảo mật SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Điều tuyến API thông thường đến Gunicorn/Daphne Container
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Điều tuyến WebSocket Chat đến ASGI Channels Container
    location /ws/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
Kích hoạt cấu hình và tải lại Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/snapspot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 4. Quy trình sao lưu dữ liệu tự động (Backup Policy)

Tạo một script chạy định kỳ hàng ngày bằng cronjob để sao lưu cơ sở dữ liệu PostgreSQL sang một thư mục an toàn hoặc máy chủ Cloud khác:

```bash
#!/bin/bash
# Đường dẫn lưu file backup
BACKUP_DIR="/var/backups/snapspot"
DATE=$(date +%Y-%m-%d_%H%M%S)
FILENAME="snapspot_db_$DATE.sql.gz"

# Tạo thư mục nếu chưa có
mkdir -p $BACKUP_DIR

# Xuất dữ liệu Database từ Docker Container và nén lại
docker compose exec -t db pg_dump -U postgres snapspot | gzip > "$BACKUP_DIR/$FILENAME"

# Dọn dẹp các bản sao lưu cũ hơn 14 ngày
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +14 -delete
```
Lập lịch chạy lúc **2h sáng hàng ngày** bằng cách thêm dòng sau vào `crontab -e`:
```text
0 2 * * * /bin/bash /opt/snapspot/scripts/db_backup.sh
```