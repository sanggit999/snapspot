# 29 - CI/CD

Tài liệu này đặc tả quy trình Tích hợp liên tục (CI) và Triển khai liên tục (CD) tự động hóa thông qua **GitHub Actions** cho dự án SnapSpot.

---

## 1. Luồng hoạt động của CI/CD (Pipeline Flow)

```text
  [ Push/PR to Git ]
         │
         ├───> [ Job 1: Lint & Code Analysis ] (Black, Flake8, Flutter Analyze)
         │
         ├───> [ Job 2: Automated Testing ]    (Django Unit Tests, Flutter Widget Tests)
         │
         └───> [ Job 3: Docker Build & Push ]  (Chỉ chạy khi merge vào main -> ECR/DockerHub)
                     │
                     ▼
               [ Job 4: Auto Deploy ]          (SSH cập nhật Production Server)
```

---

## 2. Đặc tả Kịch bản CI cho Backend (GitHub Actions)

Kịch bản được đặt tại tệp tin `.github/workflows/backend-ci.yml`. Nó tự động dựng một Database PostgreSQL trong môi trường ảo của GitHub để chạy các kiểm thử tích hợp GIS.

```yaml
name: SnapSpot Backend CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    # Khởi chạy dịch vụ cơ sở dữ liệu ảo phục vụ chạy Test
    services:
      postgres:
        image: postgis/postgis:15-3.3
        env:
          POSTGRES_DB: test_snapspot
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: testpassword
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-node: '3.11'

    # Cài đặt thư viện GIS hệ thống cần thiết trên máy chủ ảo GitHub
    - name: Install System GIS Dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y binutils gdal-bin libproj-dev proj-data libpq-dev

    - name: Install Python Dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt

    - name: Run Code Linter (Black Check)
      run: black --check .

    - name: Run Django Tests
      env:
        DB_NAME: test_snapspot
        DB_USER: postgres
        DB_PASSWORD: testpassword
        DB_HOST: localhost
        DB_PORT: 5432
        DEBUG: False
      run: python manage.py test
```

---

## 3. Đặc tả Kịch bản CI cho Frontend (Flutter CI)

Kịch bản được đặt tại tệp tin `.github/workflows/frontend-ci.yml`.

```yaml
name: SnapSpot Frontend CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze_and_test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    # Dựng môi trường Java phục vụ build Android SDK
    - name: Set up Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '17'

    # Dựng môi trường Flutter
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.x'
        channel: 'stable'

    - name: Install Dependencies
      run: flutter pub get

    - name: Run Code Formatter Check
      run: flutter format --set-exit-if-changed lib/

    - name: Run Flutter Static Analyzer
      run: flutter analyze

    - name: Run Unit & Widget Tests
      run: flutter test --coverage
```

---

## 4. Quy trình CD (Auto Deployment)
- Khi code được merge vào nhánh `main`:
  1. Trigger job build ảnh Docker mới cho Django Backend.
  2. Đẩy ảnh Docker lên Docker Hub với tag `:latest` và số hiệu commit.
  3. Sử dụng Action SSH để truy cập vào VPS Production của dự án.
  4. Thực hiện các lệnh cập nhật:
     ```bash
     cd /opt/snapspot
     docker compose pull
     docker compose up -d --no-deps web celery_worker
     docker compose exec -T web python manage.py migrate
     ```