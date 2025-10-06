//
//  WalletAppApp.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI

@main
struct WalletAppApp: App {
    let appContainer = AppContainer(environment: .mock)
    let coordinator: AppCoordinator
    
    init() {
        self.coordinator = AppCoordinator(container: appContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(coordinator)
        }
    }
}
