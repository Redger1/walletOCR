# walletOCR

A modular iOS wallet application focused on expense tracking and OCR-based receipt scanning.

The project is built using a package-oriented architecture with separated feature and infrastructure layers.

## Features

- Receipt scanning with OCR
- Expense tracking
- Budget management
- Modular Swift Package architecture
- Dependency injection
- Reusable design system
- Local persistence layer
- Feature-based navigation

## Architecture

The application is split into multiple internal Swift Packages to keep features isolated and reusable.

Current modules include:

- VisionOCRKit
- BudgetEngine
- PersistenceKit
- LoggingKit
- AnalyticsKit
- DesignSystem
- CoreTypes
- FeatureFlags

The app layer is responsible only for composition and presentation logic, while business and infrastructure logic are extracted into independent modules.

## Tech Stack

- Swift
- SwiftUI
- Vision Framework
- Swift Package Manager
- Local persistence
- Modular architecture

## Project Structure
App/
└── Wallet application layer

Packages/
├── VisionOCRKit
├── BudgetEngine
├── PersistenceKit
├── DesignSystem
├── LoggingKit
├── AnalyticsKit
└── CoreTypes## Current Status

The project is functional and demonstrates a complete modular application structure with OCR integration and feature separation.

The architecture is still evolving, and some areas are planned for future improvements, including:

- advanced OCR processing
- synchronization
- improved analytics
- test coverage
- additional budgeting features
- production-level persistence optimizations
