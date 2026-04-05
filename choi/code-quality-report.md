# UMC iOS 프로젝트 코드 품질 분석 리포트

**분석 대상:** Week1_Practice, Week2_Practice, UMC_MegaBox
**분석 일자:** 2026-03-25
**분석 기준:** Swift/SwiftUI 코드 품질, 네이밍, 아키텍처 일관성, 안티패턴

---

## 요약

37개의 Swift 파일을 분석한 결과, 5가지 주요 코드 품질 이슈를 발견했습니다. 프로젝트가 학습 과정(Week1 → Week2 → MegaBox)을 따라 진행되면서 구조화 능력이 성장하고 있지만, 아래의 반복적인 패턴들이 코드 유지보수성과 확장성을 저해하고 있습니다.

---

## Issue 1: 파일명/타입명 오타 및 불일치

**심각도:** 중간 — 협업 시 혼란을 유발하고 검색을 어렵게 만듦

발견된 오타들:

| 파일/타입명 | 문제 | 수정 제안 |
|---|---|---|
| `ProfileMangaeView.swift` | "Mangae" → "Manage" 오타 | `ProfileManageView.swift` |
| `FontManger.swift` | "Manger" → "Manager" 오타 | `FontManager.swift` |
| `MyPageView.swift` 파일 헤더 | `dView.swift`라고 표시됨 | 파일 헤더를 `MyPageView.swift`로 수정 |
| `TicketView.swift` 파일 헤더 | `Untitled.swift`라고 표시됨 | 파일 헤더를 `TicketView.swift`로 수정 |

특히 `ProfileMangaeView`는 타입명이므로 코드 전체에서 오타가 전파됩니다. UMCMegaBoxApp.swift에서도 `ProfileMangaeView()`로 호출하고 있어, 나중에 이름을 고치면 여러 파일을 동시에 수정해야 합니다.

---

## Issue 2: @AppStorage 키가 여러 파일에 중복 산재

**심각도:** 높음 — 키 불일치 시 데이터 유실 위험, 테스트 불가

현재 `@AppStorage`가 사용되는 곳:

| 파일 | 키 |
|---|---|
| `LoginView.swift` | `"id"`, `"pwd"` |
| `ProfileMangaeView.swift` (MemberInfo) | `"id"`, `"name"` |
| `ProfileHeaderView.swift` | `"name"` |
| `MovieView.swift` | `"movieName"` |

문제점:

1. **비밀번호를 평문 저장**: `@AppStorage("pwd")`는 UserDefaults에 비밀번호를 그대로 저장합니다. 실제 앱이라면 Keychain을 사용해야 합니다.
2. **매직 스트링 중복**: `"id"`라는 키가 LoginView와 MemberInfo 양쪽에 하드코딩되어 있습니다. 한쪽에서 키를 변경하면 다른 쪽과 동기화가 깨집니다.
3. **중앙화 부재**: 모든 키를 한 곳에서 관리하는 상수 파일이 없습니다.

개선 제안:

```swift
// AppStorageKeys.swift
enum AppStorageKey {
    static let userId = "userId"
    static let userName = "userName"
    static let selectedMovie = "selectedMovie"
}
```

---

## Issue 3: ViewModel이 거의 빈 껍데기

**심각도:** 중간 — MVVM 패턴을 적용했지만 실질적 역할이 없음

`LoginViewModel.swift`의 전체 코드:

```swift
@Observable
class LoginViewModel {
    var loginModel = LoginModel()
}
```

이 ViewModel은 LoginModel을 감싸기만 할 뿐, 유효성 검증, 로그인 API 호출, 에러 처리 등의 비즈니스 로직이 전혀 없습니다. 실제 로그인 처리 로직(AppStorage 저장)은 `LoginView`의 Button action에 직접 작성되어 있습니다:

```swift
// LoginView.swift 내부
Button(action: {
    id = loginVM.loginModel.id       // View에서 직접 저장
    pwd = loginVM.loginModel.pwd     // View에서 직접 저장
    print("로그인 시도 - ID: \(loginVM.loginModel.id)...")
})
```

ViewModel이 해야 할 일(저장, 검증, 상태 관리)이 View에 있으므로, MVVM의 장점(테스트 가능성, 관심사 분리)을 얻지 못하고 있습니다. 반면 `MovieViewModel`은 `previousMovie()`/`nextMovie()` 같은 로직을 잘 분리해 두었습니다.

개선 제안: LoginViewModel에 실제 로직을 넣어야 합니다:

```swift
@Observable
class LoginViewModel {
    var loginModel = LoginModel()
    var errorMessage: String?
    var isLoggedIn: Bool = false

    func login() {
        guard !loginModel.id.isEmpty, !loginModel.pwd.isEmpty else {
            errorMessage = "아이디와 비밀번호를 입력해주세요"
            return
        }
        // 저장 로직, API 호출 등
        isLoggedIn = true
    }
}
```

---

## Issue 4: UMCMegaBoxApp에서 모든 View를 동시 렌더링

**심각도:** 높음 — 앱 실행 시 4개 화면이 동시에 나타남

```swift
@main
struct UMCMegaBoxApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
            SplashView()
            MyPageView()
            ProfileMangaeView()
        }
    }
}
```

WindowGroup 안에 4개의 View가 나열되어 있어, SwiftUI가 이를 암묵적 VStack처럼 렌더링합니다. 실제 앱이라면 SplashView → LoginView → MyPageView 순서로 네비게이션이 필요합니다.

개선 제안: 상태 기반 화면 전환을 도입합니다:

```swift
@main
struct UMCMegaBoxApp: App {
    @State private var appState: AppState = .splash

    var body: some Scene {
        WindowGroup {
            switch appState {
            case .splash:  SplashView()
            case .login:   LoginView()
            case .main:    MyPageView()
            }
        }
    }
}
```

또는 NavigationStack을 사용한 경로 기반 네비게이션도 좋은 선택입니다.

---

## Issue 5: 하드코딩된 매직 넘버와 색상값

**심각도:** 낮음~중간 — 디자인 변경 시 여러 곳을 수정해야 함

`ClubMembershipButton` 내부의 그라데이션 색상이 직접 하드코딩되어 있습니다:

```swift
LinearGradient(
    stops: [
        Gradient.Stop(color: Color(red: 0.67, green: 0.55, blue: 1), location: 0.00),
        Gradient.Stop(color: Color(red: 0.56, green: 0.68, blue: 0.95), location: 0.53),
        Gradient.Stop(color: Color(red: 0.36, green: 0.8, blue: 0.93), location: 1.00),
    ], ...
)
```

프로젝트에 이미 `Colors.xcassets`에 blue00~09, purple00~09, gray00~09 같은 시맨틱 컬러 세트가 잘 정의되어 있는데, 정작 View 코드에서는 RGB 값을 직접 쓰고 있습니다. `ProfileHeaderView`의 `Color(red: 0.28, green: 0.8, blue: 0.82)`도 마찬가지입니다.

추가로, 프레임 크기도 매직 넘버입니다:

```swift
.frame(width: 385, height: 386)  // TicketView — 기기 대응 불가
.frame(width: 17.47, height: 29.73)  // MovieView chevron — 소수점 픽셀?
.padding(.bottom, 250)  // LoginView — 기기별로 깨질 수 있음
```

개선 제안: 색상은 xcassets를 활용하고, 크기는 상대적 레이아웃(`GeometryReader`, `.frame(maxWidth: .infinity)` 등)을 사용합니다.

---

## 추가 발견 사항

### TicketView의 구조적 버그

`TicketView.swift`에서 `mainBottomGroup`이 struct 밖에 정의되어 있습니다:

```swift
struct TicketView: View {
    var body: some View { ... }
    private var mainTitleGroup: some View { ... }
}  // ← struct 닫힘

private var mainBottomGroup: some View {  // ← struct 바깥!
    Button(action: { ... }) { ... }
}
```

이 코드는 `mainBottomGroup`이 전역 수준의 computed property가 되어, 의도와 다르게 동작할 수 있습니다. struct 안으로 이동해야 합니다.

### MovieModel에 Image 타입 직접 저장

```swift
struct MovieModel {
    let movieImage: Image  // SwiftUI View 타입
    let movieName: String
}
```

`Image`는 SwiftUI View 타입이므로 Model에 넣기보다는 이미지 이름(String)이나 리소스 식별자를 저장하고, View에서 `Image()`로 변환하는 것이 MVVM 원칙에 맞습니다. 이렇게 하면 Model을 Codable로 만들 수 있고, 네트워크에서 받은 데이터와도 호환됩니다.

### 불필요한 import

`LoginModel.swift`에서 `import SwiftUI`를 사용하고 있지만, SwiftUI 타입을 전혀 사용하지 않습니다. `import Foundation`만으로 충분합니다. Model 레이어는 UI 프레임워크에 의존하지 않는 것이 좋습니다.

---

## 우선순위 정리

| 순위 | 이슈 | 이유 |
|---|---|---|
| 1 | App 진입점 수정 (Issue 4) | 앱이 정상 동작하지 않음 |
| 2 | @AppStorage 키 중앙화 (Issue 2) | 데이터 정합성, 보안 |
| 3 | ViewModel에 로직 이동 (Issue 3) | MVVM 패턴의 실질적 활용 |
| 4 | 파일명 오타 수정 (Issue 1) | 코드 검색성, 협업 |
| 5 | 매직 넘버 제거 (Issue 5) | 유지보수성 |

---

*이 리포트는 UMC iOS 학습 프로젝트의 37개 Swift 파일을 분석하여 작성되었습니다.*
