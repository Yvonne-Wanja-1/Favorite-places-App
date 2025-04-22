# Favorite Places

**Favorite Places** is a Flutter-based app that allows users to save, manage, and revisit their favorite locations. The app integrates with Google Maps for location selection and preview, and it uses local storage to keep track of places offline.

## Features

- **Save Favorite Places**: Add a title, image, and precise location for each place.
- **Google Maps Integration**: Select locations interactively or view static map previews.
- **Camera Support**: Capture images directly from the app.
- **Offline Storage**: Save places locally using Sqflite for easy access anytime.
- **Modern UI**: Built with Material Design 3 and custom themes using Google Fonts.
- **State Management**: Powered by Riverpod for efficient and reactive state handling.

## Technologies Used

- **Flutter**: Cross-platform app development.
- **Google Maps API**: For map integration and location services.
- **Riverpod**: State management.
- **Sqflite**: Local database for storing places.
- **Flutter Dotenv**: For managing environment variables.
- **Google Fonts**: Custom typography with Ubuntu Condensed.

## Getting Started

### Prerequisites

- Flutter SDK installed on your machine.
- A valid Google Maps API key with the following APIs enabled:
  - Geocoding API
  - Static Maps API
  - Maps SDK for Android/iOS

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/great-places.git
   cd great-places
