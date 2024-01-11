# 프로젝트 소개
![intro](https://github.com/MojitoBar/pins/assets/16567811/e088d4de-4b83-47f2-b7f4-271edeaf4be5)

지도 기반 SNS 서비스를 개발함으로써 다양한 기술의 통합적 역량을 높이고자 시작한 프로젝트입니다. <br>
이 프로젝트의 핵심은 사용자가 지도에 핀을 생성하여 커뮤니티와 소통하는 것입니다.

# 기술적 고민
- [유지보수와 확장에 용이한 구조 설계](https://github.com/f-lab-edu/pins/wiki/%EC%9C%A0%EC%A7%80%EB%B3%B4%EC%88%98%EC%99%80-%ED%99%95%EC%9E%A5%EC%97%90-%EC%9A%A9%EC%9D%B4%ED%95%9C-%EA%B5%AC%EC%A1%B0-%EC%84%A4%EA%B3%84)
- [이미지가 포함된 게시물 로드 속도 개선](https://github.com/f-lab-edu/pins/wiki/%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%ED%8F%AC%ED%95%A8%EB%90%9C-%EA%B2%8C%EC%8B%9C%EB%AC%BC-%EB%A1%9C%EB%93%9C-%EC%86%8D%EB%8F%84-%EA%B0%9C%EC%84%A0)
- [회원 탈퇴를 위한 재인증](https://github.com/f-lab-edu/pins/wiki/%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%ED%8F%AC%ED%95%A8%EB%90%9C-%EA%B2%8C%EC%8B%9C%EB%AC%BC-%EB%A1%9C%EB%93%9C-%EC%86%8D%EB%8F%84-%EA%B0%9C%EC%84%A0)
- [맵 어노테이션 클러스터링 이슈](https://github.com/f-lab-edu/pins/wiki/%EB%A7%B5-%EC%96%B4%EB%85%B8%ED%85%8C%EC%9D%B4%EC%85%98-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0%EB%A7%81-%EC%9D%B4%EC%8A%88)
- [CI/CD 구현 중 Xcode 최신 버전 이슈](https://github.com/f-lab-edu/pins/wiki/CI-CD-%EA%B5%AC%ED%98%84-%EC%A4%91-Xcode-%EC%B5%9C%EC%8B%A0-%EB%B2%84%EC%A0%84-%EC%9D%B4%EC%8A%88)

# 주요 기능
- 로그인
  - 구글 소셜 로그인
  - 애플 소셜 로그인
  - 자동 로그인
- 메인 맵 뷰
  - 어노테이션 불러오기
  - 클러스터링
  - 내 위치로 가기
  - 게시물 작성 버튼
  - 새로고침 버튼
- 게시물 생성 뷰
  - 갤러리 이미지 선택
  - 게시물 생성 로딩
- 디테일 뷰
  - 이미지 스크롤
  - 댓글 작성
- 옵션
  - 로그아웃
  - 회원탈퇴
  - 캐시 삭제

# 기술 스택

<img src="https://img.shields.io/badge/Swift-5.9-5C5C5C?logo=Swift&color=5C5C5C&labelColor=ffffff"/> <img src="https://img.shields.io/badge/Xcode-15.1-FF4154?logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/iOS-15.0-CCFBF2?logo=ios&logoColor=white"/> 

### 구현 아키택처
Clean Architecture + MVVM
<details>
<summary>역할 분리 기준</summary>
<div markdown="1">

**Presentation 레이어**
- View: 사용자 인터페이스와 관련된 로직만을 포함하며, 구성 요소의 정의와 상호작용을 담당합니다. View는 UI와 직접적인 상호작용을 하는 역할만을 수행해야 합니다.
- ViewController: View와 ViewModel 사이의 중개자 역할을 합니다. 사용자의 입력을 처리하고 ViewModel의 상태 변화를 감지하여 View를 업데이트합니다.
- ViewModel: ViewController의 상태값을 보유하고, UseCase에 요청을 전달하여 상태값을 활용합니다. ViewModel은 UI 로직과 비즈니스 로직의 분리를 돕습니다.

**Domain 레이어**
- Entity: 비즈니스 로직의 핵심적인 데이터 구조를 정의합니다.
- UseCase: 비즈니스 로직을 수행합니다. ViewModel로부터 받은 요청을 처리하고, UI에 필요한 데이터 형식으로 가공합니다. 예를 들어, 서버에서 받은 데이터를 사용자 인터페이스에 표시하기 적합한 형태로 변환하는 역할을 합니다.

**Data 레이어**
- Service: 외부 데이터 소스(예: API)와의 통신을 담당합니다. Repository로부터 받은 데이터를 Domain 레이어가 이해할 수 있는 형태로 가공합니다.
- Repository: 데이터의 영속성 관리를 담당합니다. 데이터베이스나 웹 서비스 등으로부터 데이터를 CRUD하는 역할을 합니다.

</div>
</details>

### 사용 라이브러리
- [firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk)
- [GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS)
- [ios-snapshot-test-case](https://github.com/uber/ios-snapshot-test-case)
