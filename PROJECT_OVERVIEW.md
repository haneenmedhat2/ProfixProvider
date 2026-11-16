# ProfixProvider — iOS Application

## Overview

**ProfixProvider** is a service-provider iOS application that lets professionals (plumbers, electricians, technicians, etc.) offer and manage services, handle customer orders, track finances, and chat with customers in real time.

| Field | Value |
|-------|-------|
| Display Name | ProfixProvider |
| Bundle ID | `com.aait.ProfixProvider` |
| Version | 1.0 |
| iOS Deployment Target | 15.6 |
| Swift Version | 5.0 |
| Firebase Project | `profix-694ea` |
| Supported Languages | Arabic (`ar`), English (`en`), Urdu (`ur-Arab`) |

---

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern organized by feature modules.

```
ProfixProvider/
├── Core/            # AppDelegate, SceneDelegate, app lifecycle
├── App/             # Feature modules (Auth, Home, Orders, Chat, …)
├── Networking/      # Endpoints, request/response handling, errors
├── Shared/          # Extensions, helpers, reusable UI, types
├── Storage/         # UserDefaults wrappers (property wrappers)
├── Validation/      # Form validation service
├── Localization/    # .strings files (ar / en / ur-Arab)
└── Resources/       # Assets, fonts, Lottie animations
```

---

## Tech Stack

All dependencies are integrated via **Swift Package Manager**.

### Firebase
- FirebaseCore, FirebaseMessaging (FCM)
- FirebaseAuth, FirebaseAnalytics
- FirebaseDatabase, FirebaseFirestore, FirebaseFunctions
- FirebaseStorage, FirebaseInstallations
- FirebaseAppDistribution-Beta

### Third-Party
- **Alamofire** — HTTP networking
- **Kingfisher** — Image downloading & caching
- **IQKeyboardManagerSwift** + IQKeyboardToolbarManager — keyboard handling
- **Google Maps SDK** — maps and geolocation
- **Socket.IO (SocketIO)** — real-time chat
- **Lottie** — animations
- **Microsoft Clarity** — session analytics, installed from `microsoft/clarity-apps` (`main`) through Swift Package Manager; initialized in `AppDelegate` with project ID `ywin1s1s3s`
- **AppsFlyer** — provider order analytics, using `AppsFlyerFramework-Static` 6.18.1 through Swift Package Manager

---

## Feature Modules (`App/`)

| Module | Purpose |
|--------|---------|
| **Intro** | Onboarding flow; `SplashVC` is the root entry |
| **Auth** | Login, Signup, Forget/Reset Password, Verification |
| **Home** | Dashboard, booking locations, previous-work showcase |
| **Services** | MyServices (CRUD), ServiceDetails, UpdateService |
| **Orders** | Order management, OrderDetails, CreateInvoice, PaymentMethodPopup, geo-location, problem description |
| **Chat** | Real-time messaging via Socket.IO — text, image, file, video, sound, and map message types; ImageViewer |
| **Notification** | Notification center, `NotificationCountManager`, FCM payload handling |
| **FCM** | Push notification setup, `GoogleService-Info.plist` |
| **More** | Settings, Profile, Financials (transactions, due balance), MyRatings, MyPreviousWork, Terms & Conditions, Privacy Policy, Terms of Use, Contact Us, Complaints & Inquiries, About Us |

---

## Networking Layer

Clean, protocol-oriented architecture with modern `async/await`.

- **`Endpoint.swift`** — Generic endpoint: server, method, path, headers, queries, body, uploads, decoder
- **`RequestHeader`** — Authorized / unauthorized header builders
- **`Requestable`** — Protocol implemented by concrete request types
- **`NetworkService`** — Public async protocol used by view models
- **`DefaultNetworkExecuter`** — Alamofire adapter with multipart upload + progress callbacks
- **`BaseResponse<T>`** — Wrapper with `key: ServerResponseKey`, `message`, `data`, `userStatus`
- **`ResponseHandler`** — Decoding and validation
- **`ResponseError`** — `canNotConnectToServer`, `serverError`, `unableToDecodeResponse`, `server(message)`, `unAuthorized`, `blocked`, `exception`, `needActive`

Endpoints are split by feature: `AuthEndpoints`, `HomeEndPoints`, `OrdersEndPoints`, `ChatEndPoints`, `NotificationsEndPoints`, `ServicesEndPoints`, `MoreEndPoints`, etc.

---

## Storage

UserDefaults-based with two Swift property wrappers:

- `@ValueDefault<Value>` — primitives (String, Bool, Int…)
- `@ModelsDefault<Model: Codable>` — JSON-encoded Codable models

### Persisted Keys
`googleMapKey`, `accessToken`, `pushNotificationToken`, `isFirstTime`, `isLogin`, `notificationCount`, `user` (User), `currentLocation` (AddressModel), `isNotify`, `languageChanged`.

---

## Push Notifications (FCM)

Configured in `Core/AppDelegate.swift`:
- `FirebaseApp.configure()` at launch
- `Messaging.messaging().delegate = self`
- `UNUserNotificationCenter.current().delegate = self`
- `application.registerForRemoteNotifications()`

Firebase project: **profix-694ea** (GCM Sender ID `336977842277`).

---

## Provider Analytics (AppsFlyer)

- `Shared/Helper/Analytics/AppAnalytics.swift` owns the AppsFlyer SDK calls and event/parameter constants.
- `AppDelegate` configures the SDK at launch; `SceneDelegate.sceneDidBecomeActive` starts it on activation.
- `APPSFLYER_DEV_KEY` is configured in the **ProfixProvider target's Debug and Release build settings**. `Info.plist` reads that setting as `AppsFlyerDevKey`. The provider App Store ID is `6759157615`.
- `LoginVM` emits **`login_success`** without parameters after the login API returns `key: success` with user data. Pending approval, verification, refused, failed, and cancelled attempts emit no event.
- `AddNewServiceVM` emits **`service_added`** without parameters after `add-service` returns `key: success`. Failed and cancelled attempts emit no event; duplicate submissions are blocked while the request runs and after success within the same view model.
- `OrderDetailsVM.acceptOrderRequest()` emits **`order_accepted`** with integer **`order_id`** only after `delegate-accept-order` returns `key: success`. It blocks duplicate submissions while the request is running and after success within the same view model; failed attempts can be retried.
- `OrderDetailsVM.finsihOrderRequest(code:)` emits **`order_finished`** with integer **`order_id`** only after `delegate-finish-order` returns `key: success`. It uses the same order ID as the request.
- Invalid finish codes, failed/cancelled requests, and other response keys emit no event. Duplicate submissions are blocked while the request is running and after success within the same view model. Failed attempts can be retried.
- `order_created` and `order_paid` belong to the customer app and are not emitted here.
- `ProfixProviderTests/OrderFinishAnalyticsTests.swift` covers success timing, order ID/code matching, invalid-code retry, non-success responses, network failure/cancellation, and duplicate submissions using mocked responses and analytics.
- `ProfixProviderTests/LoginAndOrderAcceptanceAnalyticsTests.swift` covers login response gating and acceptance success, retry, order ID, and duplicate submissions.
- `ProfixProviderTests/ServiceAddedAnalyticsTests.swift` covers service creation response gating, retry, and duplicate submissions.
- When hosted unit tests run, the app skips normal UI startup and live SDK initialization.
- In Debug builds, filter the Xcode console by `[AppsFlyer][Provider]` to follow SDK configuration/start callbacks, finish API outcomes, skipped duplicate attempts, and `order_finished` submission callbacks. These custom logs include order IDs and error domains/codes, but omit the dev key, finish code, and raw response payloads. They are disabled in Release builds.

Run the tests with the `ProfixProvider` scheme's Test action in Xcode. Verify end-to-end delivery on an AppsFlyer test device using a successful provider order completion.

---

## Validation

`ValidationService` (~642 lines) exposes static validators covering:

- **Identity** — firstName, lastName, fullName, familyName, providerName
- **Contact** — phone (Saudi Arabia pattern), email, newPhone
- **Auth** — password (8+ chars), 4-digit verification code
- **Location** — country, governorate, city, area, street, addressDetails, coordinates
- **Images** — profile, license, product, car
- **Bank** — account holder, IBAN (`SA\d{22}`), account number, transfer image
- **Services** — name, price, description, categoryId
- **Financial** — amount (with Arabic-numeral conversion `٠-٩ → 0-9`), executionDate, executionTime, location
- **Complaints** — title, description

Errors surface through a `ValidationError` enum with 80+ cases.

---

## Localization & Fonts

- **Languages:** Arabic, English, Urdu (RTL aware via `Language.isRTL()`)
- **Files:** `Localizable.strings`, `InfoPlist.strings`
- **Font family:** *IBM Plex Sans Arabic* in 7 weights (Bold, SemiBold, Medium, Regular, Light, ExtraLight, Thin)
- Runtime font replacement via `UIFont.overrideInitialize()` using `method_exchangeImplementations`

---

## Entry Point

1. `Core/AppDelegate.swift` is marked `@main` and handles:
   - `UIFont.overrideInitialize()` — swaps system font to IBM Plex Sans Arabic
   - Google Maps SDK initialization
   - `IQKeyboardManager` (enabled globally, disabled for `ChatVC`)
   - Firebase + FCM + remote-notification registration
2. `SceneDelegate` sets `SplashVC` (from `SplashVC.xib`) as the root.
3. Interface style is locked to **light**.
4. Posts `appDidBecomeActive` notification on foreground.

---

## Resources

- **Assets:** `Assets.xcassets` with app theme colors and image sets
- **App Icon:** `AppIcon.appiconset/Icon-1024.png`
- **Animations:** `LottieFile/` with Lottie JSON files

---

## Code-Quality Highlights

- Modern `async/await` networking layer
- Strongly-typed error handling (`ResponseError`, `ValidationError`)
- Full RTL/i18n support
- Rich Socket.IO chat with multiple message types
- Multipart uploads with progress tracking
- Property-wrapper-based persistence keeps state code concise
