//
//  RootView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import SwiftUI

struct RootView: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    var body: some View {
        TabView(selection: coordinator.binding(\.selectedTab)) {
            NavigationStack(path: coordinator.binding(\.homePath)) {
                coordinator.buildHome()
                    .navigationDestination(for: HomeRoute.self, destination: coordinator.destination)
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(Tab.home)
            
            NavigationStack(path: coordinator.binding(\.transactionPath)) {
                coordinator.buildTransaction()
                    .navigationDestination(for: TransactionRoute.self, destination: coordinator.destination)
            }
            .tabItem { Label("Transactions", systemImage: "arrow.up.arrow.down") }
            .tag(Tab.transactions)
            
            NavigationStack(path: coordinator.binding(\.budgetPath)) {
                coordinator.buildBudget()
                    .navigationDestination(for: BudgetRoute.self, destination: coordinator.destination)
            }
            .tabItem { Label("Budget", systemImage: "pencil") }
            .tag(Tab.budget)
        }
    }
}
