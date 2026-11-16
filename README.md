# ProfixProvider

ProfixProvider is the service-provider companion app for the Profix marketplace. It helps professionals manage their service listings, receive and fulfill customer bookings, communicate with customers, and track their earnings.

## Features

- Provider home dashboard with order statistics and new booking alerts
- Create, update, and manage service listings and prices
- Review and manage new, active, and completed orders
- View booking details, customer contact information, and service location
- Update order status and coordinate service visits
- Chat with customers using text and media messages
- Track financial transactions, commissions, taxes, and due balances
- Manage provider profile, ratings, availability, and previous work gallery
- Receive push notifications and order updates
- Arabic, English, and Urdu localization with right-to-left support

## Screenshots

### Dashboard and orders

| Home dashboard | Orders | Order details |
|:---:|:---:|:---:|
| <img src="Screenshots/home-dashboard.png" alt="Provider dashboard" width="260"> | <img src="Screenshots/orders.png" alt="Provider orders" width="260"> | <img src="Screenshots/order-details.png" alt="Order details" width="260"> |

### Services, finances, and profile

| Services | Financial transactions | More |
|:---:|:---:|:---:|
| <img src="Screenshots/services.png" alt="Provider services" width="260"> | <img src="Screenshots/financial-transactions.png" alt="Financial transactions" width="260"> | <img src="Screenshots/more.png" alt="Provider account options" width="260"> |

### Previous work

<img src="Screenshots/previous-work.png" alt="Provider previous work gallery" width="300">

## Tech Stack

- Swift 5 and UIKit
- MVVM architecture with Combine and async/await
- Alamofire for HTTP networking
- Firebase for authentication, data, storage, analytics, and push notifications
- Google Maps for service locations
- Socket.IO for real-time chat
- Kingfisher, Lottie, and AppsFlyer
- Swift Package Manager

## Run the App

1. Install Xcode on macOS.
2. Open `ProfixProvider.xcodeproj`.
3. Allow Xcode to resolve Swift Package Manager dependencies.
4. Select the `ProfixProvider` scheme and an iPhone simulator or development device.
5. Build and run the app.

The app depends on project-specific Firebase, Google Maps, backend, analytics, and signing configuration. Obtain required values and access from the project owner. Do not commit private credentials or production secrets.

## Project Structure

- `ProfixProvider/App` — authentication, dashboard, services, orders, chat, notifications, and account features
- `ProfixProvider/Core` — application and scene lifecycle
- `ProfixProvider/Networking` — API endpoints, request handling, and response decoding
- `ProfixProvider/Shared` — reusable views, helpers, and extensions
- `ProfixProvider/Resources` — images, fonts, colors, and animations
- `ProfixProvider/Localization` — Arabic, English, and Urdu language support
- `ProfixProvider/Validation` — input validation
