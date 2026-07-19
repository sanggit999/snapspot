# 00 - Project Overview

> Version: 1.0.0

> Status: Draft

> Last Updated: 2026-07-15

---

# Project Name

SnapSpot

---

# Project Type

Location-Based Photo Social Network

---

# Slogan

Capture the World.

---

# Description

SnapSpot là nền tảng mạng xã hội chia sẻ ảnh theo vị trí.

Người dùng có thể:

- Chụp ảnh
- Đăng ảnh
- Đính kèm vị trí GPS
- Theo dõi bạn bè
- Bình luận
- Thích bài viết
- Khám phá địa điểm gần mình
- Tìm kiếm địa điểm đẹp

---

# Vision

Trở thành nền tảng chia sẻ ảnh địa điểm hàng đầu thế giới.

---

# Mission

Giúp mọi người khám phá thế giới thông qua hình ảnh.

---

# Target Users

- Traveler
- Photographer
- Food Reviewer
- Cafe Reviewer
- Backpacker
- Content Creator

---

# Platforms

- Android
- iOS

Roadmap

- Web
- Windows
- macOS

---

# Languages

Current

- Vietnamese
- English

Future

- Japanese
- Korean
- Chinese

---

# Core Features

## Authentication

- Register
- Login
- Forgot Password
- Google Login
- Apple Login

---

## Social

- Feed
- Story
- Comment
- Like
- Share
- Friend
- Follow
- Chat

---

## Location

- GPS
- Map
- Nearby Feed
- Distance
- Explore

---

## Media

- Camera
- Gallery
- Video
- Multiple Images

---

## Search

- User
- Place
- Hashtag
- Trending

---

## Notification

- Push Notification

- In App Notification

---

## Settings

- Theme

- Language

- Privacy

- Security

---

# Business Goal

- Build Community
- Grow User Base
- Increase Engagement
- Become Travel Platform

---

# High Level Architecture

Flutter

↓

REST API

↓

Django REST Framework

↓

Service Layer

↓

Django ORM

↓

PostgreSQL

↓

Redis

↓

Celery

↓

MinIO

↓

Firebase Cloud Messaging

↓

Docker

↓

Nginx

---

# Tech Stack

## Frontend

- Flutter
- Dart
- BLoC (Cubit)
- Go Router
- Dio
- Freezed
- Hive
- Flutter Secure Storage

---

## Backend

### Language

- Python

### Framework

- Django
- Django REST Framework

### Realtime

- Django Channels

### Authentication

- JWT

- Refresh Token

### Background Job

- Celery

- Celery Beat

### Database

- PostgreSQL

### Cache

- Redis

### Storage

- MinIO

### Notification

- Firebase Cloud Messaging

---

## DevOps

- Docker
- Docker Compose
- GitHub Actions
- Nginx

Future

- Kubernetes

---

# Coding Standards

Frontend

- Clean Architecture

- MVVM

- SOLID

- DRY

Backend

- Django Best Practices

- PEP8

- Type Hint

- Service Layer

- Repository Pattern (Optional)

---

# Non Functional Requirements

Performance

- API < 500ms

- Startup < 2s

- Lazy Loading

- Infinite Scroll

Security

- HTTPS

- JWT

- Refresh Token Rotation

- Secure Storage

Scalability

- Millions of Users

---

# Success Metrics

- DAU

- MAU

- Session Time

- Upload Count

- Like Count

- Comment Count

- Retention

---

# Future

Version 1

- Feed

- Upload

- GPS

Version 2

- Story

- Chat

Version 3

- AI

- Recommendation

Version 4

- Web

- Desktop

---

# Project Documents

01-glossary.md

02-business-rules.md

03-functional-requirements.md

04-non-functional-requirements.md

...

35-release-notes.md
