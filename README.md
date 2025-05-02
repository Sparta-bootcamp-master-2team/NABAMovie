# NABAMOVIE 🎬

**NABAMOVIE**는 **내일배움캠프 무비**의 줄임말로, 영화 예매부터 로그인, 회원가입, 영화 검색, 영화 즐겨찾기, 마이페이지까지 통합적으로 제공하는 **iOS 영화 예매 앱**입니다.  
Firebase 기반 인증 시스템과 영화 정보 관리를 통해 사용자에게 실시간 영화 예매 경험을 제공합니다.  
UIKit Codebase 기반으로 구성되었으며, **Clean Architecture + MVVM-C**를 도입하여 유지보수성과 확장성을 고려해 설계되었습니다.

---

## 🗓 프로젝트 기간

2025년 4월 25일 ~ 2025년 5월 2일 (총 8일간 진행)

---

## 🎯 프로젝트 목표

### ✅ 프로젝트 개요

**NABAMOVIE**는 스마트폰으로 간편하게 영화를 예매하는 흐름을 직접 구현하며,  
사용자가 원하는 영화를 **검색하고**, **예매하고**, **예매 내역을 확인할 수 있는 전 과정을 앱으로 경험**할 수 있도록 구성한 프로젝트입니다.

단순한 화면 UI 구현을 넘어,  
- **Firebase 기반 인증 시스템**  
- **외부 영화 API를 활용한 검색 기능**  
- **예매 플로우와 사용자 편의성을 고려한 UI/UX**  
를 직접 설계하고 적용하면서, 실제 사용자를 고려한 앱을 개발하는 것이 주요 목표입니다.

또한, 기능을 단순히 구현하는 데 그치지 않고,  
**데이터 흐름과 객체 역할, 화면 간 전환 흐름까지 아키텍처 관점에서 분리하고 설계**하는 훈련을 통해,  
더 나은 구조와 유지보수 가능한 코드를 지향하는 개발 경험을 목표로 삼았습니다.

---

### 🧠 팀 목표

- **팀명:** 우린 깐부잖아 👊  
- **팀 목표:**  
  좋은 아키텍처란 무엇인지 고민하며 직접 설계하고 구현해보는 과정을 통해,  
  **실제 현업에서도 적용 가능한 구조적 사고와 개발 경험을 쌓는 것**이 목표입니다.

---

### 👤 개별 목표

| 이름 | 개인 목표 |
|------|-----------|
| 박주성 | 클린 아키텍처를 적용할 때 **레이어를 나누는 나만의 기준**을 만들고 싶다. |
| 양원식 | 클린 아키텍처에 대한 이해도를 높이고, **UIKit으로 로그인 기능**을 구현해보고 싶다. |
| 정근호 | 클린 아키텍처를 이해하고, **기타 전반적인 개발 실력 향상**을 목표로 한다. |
| 이민재 | 클린 아키텍처를 이해하고, **데이터 흐름과 객체 역할을 명확히 분리하여 구현**하고 싶다. |

---

## 📁 디렉토리 구조

```
NABAMovie/
├── App
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Coordinator
│   └── Factory
│
├── Data
│   ├── Network
│   │   ├── APIManager.swift
│   │   └── DTO
│   ├── RepositoryImpl
│   └── Service
│       └── FirebaseService.swift
│
├── Domain
│   ├── Entities
│   ├── Protocols
│   └── UseCases
│
├── Presentation
│   ├── HomeView
│   ├── BookingPage
│   ├── Login
│   ├── Signup
│   └── MyPage
│
├── Resources
├── Utils
└── Extensions
```

---

## 📱 주요 기능

| 기능 구분           | 설명 |
|--------------------|------|
| 🔐 로그인 / 회원가입 | - Firebase Authentication을 이용한 로그인 및 회원가입<br>- 회원가입 후 자동 로그인 처리<br>- 로그인 상태 유지<br>- 마이페이지에서 로그아웃 시 로그인 화면으로 이동 |
| 🎞 현재 상영작 / 개봉 예정 영화 | - 섹션 분리된 컬렉션 뷰<br>- 포스터, 제목, 상영시간, 장르 표시<br>- 캐러셀 무한 스크롤 |
| 📄 영화 상세 정보 | - 줄거리, 감독, 출연진, 스틸컷 표시<br>- 찜하기 및 예매하기 버튼 포함 |
| ❤️ 영화 찜하기 기능 | - Firebase 저장<br>- 찜 시 Toast 메시지 표시 |
| 🔍 영화 검색 기능 | - 실시간 검색 필터링<br>- 2열 그리드 UI |
| 🎟 영화 예매 기능 | - Firebase 저장<br>- 러닝타임 기반 상영 시간 선택 |
| 👤 마이페이지 | - 로그아웃<br>- 예매 내역 조회 및 삭제<br>- 찜한 영화 목록 조회 및 삭제 |

---

## ✅ 구현 체크리스트

- [x] **로그인 / 회원가입**
  - [x] Firebase 로그인 / 회원가입
  - [x] 자동 로그인
  - [x] 상태 유지
  - [x] 로그아웃 처리

- [x] **홈 화면**
  - [x] 섹션 분리 컬렉션 뷰
  - [x] 포스터, 장르, 상영시간 표시
  - [x] 캐러셀 UI

- [x] **영화 상세**
  - [x] 줄거리, 출연진, 스틸컷
  - [x] 찜 / 예매 버튼

- [x] **찜하기**
  - [x] Firebase 저장
  - [x] Toast 메시지

- [x] **검색**
  - [x] 실시간 필터링
  - [x] 2열 그리드 UI

- [x] **예매**
  - [x] Firebase 저장
  - [x] 동적 상영 시간 선택

- [x] **마이페이지**
  - [x] 사용자 정보 표시
  - [x] 예매 내역 / 삭제
  - [x] 찜 목록 / 삭제

---

## 📸 주요 화면

| 화면 | 설명 | 미리보기 |
|------|------|-----------|
| 로그인 / 회원가입 | Firebase 인증 기반 화면 | (추가 예정) |
| 홈 화면 | 현재 상영작 / 개봉 예정작 캐러셀 UI | (추가 예정) |
| 영화 상세 화면 | 상세 정보, 찜 / 예매 버튼 포함 | (추가 예정) |
| 검색 화면 | 실시간 필터링 UI | (추가 예정) |
| 예매 화면 | 시간 선택 및 예매 | (추가 예정) |
| 마이페이지 | 예매 내역, 찜 목록, 로그아웃 | (추가 예정) |

---

## 🧩 기술 스택

| 구분 | 사용 기술 |
|------|-----------|
| **언어** | Swift |
| **타겟 OS** | iOS 16.0 이상 |
| **UI 프레임워크** | UIKit (코드베이스 기반) |
| **아키텍처** | Clean Architecture + MVVM-C |
| **레이아웃** | SnapKit |
| **비동기 처리** | async/await |
| **이미지 로딩** | Kingfisher |
| **패키지 관리** | Swift Package Manager (SPM) |
| **인증 및 DB** | Firebase Auth / Firestore |
| **버전 관리** | Git, GitHub |
| **외부 API** | [TMDB API](https://developer.themoviedb.org/) |
| **협업 도구** | Notion, GitHub, Figma, Slack |

---

## 🚀 실행 방법

1. **프로젝트 클론**
   ```bash
   git clone https://github.com/your-team/NABAMovie.git
   cd NABAMovie
   ```

2. **Xcode에서 프로젝트 열기**
   - `NABAMovie.xcodeproj` 파일 실행

3. **패키지 설치 확인**
   - Xcode에서 자동 설치
   - 필요 시 `File > Packages > Resolve Package Versions`

4. **Firebase 및 API 키 설정**
   - `Resources` 폴더에 다음 파일 추가:
     - `GoogleService-Info.plist`
     - `Secrets.xcconfig`

5. **빌드 및 실행**
   - Xcode 실행 버튼 ▶️ 클릭

> ⚠️ 위 파일이 없으면 Firebase 및 TMDB API 기능은 동작하지 않습니다.

---

## 🤝 팀원 소개

| 이름 | 역할 | GitHub |
|------|------|--------|
| 박주성 |      | [@](https://github.com/) |
| 양원식 | 로그인 · 회원가입 UI, Firebase + Service 구성 / 관련 Repository, UseCase, DTO, RepositoryImpl, UserEntity 설계 및 작성 | [@_GGDol](https://github.com/Sheep1sik) |
| 정근호 |      | [@](https://github.com/) |
| 이민재 |      | [@](https://github.com/) |
