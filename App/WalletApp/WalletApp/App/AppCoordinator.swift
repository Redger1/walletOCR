//
//  AppCoordinator.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import Observation
import SwiftUI
import VisionOCRKit

enum Tab: String, Codable, Hashable {
    case home, transactions, budget, settings
}

@Observable @MainActor
final class AppCoordinator {
    let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    var selectedTab: Tab = .home
    var homePath: [HomeRoute] = []
    var transactionPath: [TransactionRoute] = []
    var budgetPath: [BudgetRoute] = []
    
    func switchTab(_ tab: Tab) { selectedTab = tab }
    
    func go(_ route: HomeRoute) { homePath.append(route) }
    func go(_ route: TransactionRoute) { transactionPath.append(route) }
    func go(_ route: BudgetRoute) { budgetPath.append(route) }
    
    func popHome() { homePath.removeLast() }
    func popTransaction() { transactionPath.removeLast() }
    func popBudget() { budgetPath.removeLast() }
    
    // HOME
    @ViewBuilder func buildHome() -> some View {
        VStack {
            Button("Open scan")     { self.go(.scan) }
            Button("Open settings") { self.switchTab(.settings) }
        }
        .navigationTitle("Home")
    }
    @ViewBuilder func destination(for route: HomeRoute) -> some View {
        switch route {
            case .scan: ScanView() {
                Task {
                    let draft = await self.container.scanService.scan()
                    self.go(.review(draft))
                }
            }
            case .review(let draft):
                let vm = ReviewViewModel(
                    draft: draft,
                    classifier: container.classifier,
                    transactionRepo: container.transactionRepository
                )
                
                ReviewView(reviewVM: vm) {
                    self.homePath.removeAll()
                } goBack: {
                    self.popHome()
                }
        }
    }
    
    // TRANSACTIONS
    @ViewBuilder func buildTransaction() -> some View {
        let vm = TransactionViewModel(
            transactionRepository: container.transactionRepository,
            csvExportService: container.csvExportService
        )
        
        TransactionView(viewModel: vm).navigationTitle("Транзакции")
    }
    @ViewBuilder func destination(for route: TransactionRoute) -> some View {
        switch route {
            case .details(let id):
                TransactionDetailsView(id: id) { self.popTransaction() }
        }
    }
    
    // BUDGET
    @ViewBuilder func buildBudget() -> some View {
        let vm = BudgetViewModel(
            transactionRepository: container.transactionRepository,
            budgetRepository: container.budgetRepository,
            calculator: container.budgetCalculator
        )
        
        BudgetView(viewModel: vm).navigationTitle("Бюджет")
    }
    @ViewBuilder func destination(for route: BudgetRoute) -> some View {
        switch route {
            case .category(let id):
                BudgetCategoryView(id: id) { self.popBudget() }
        }
    }
    
    // SETTINGS
    @ViewBuilder func buildSettings() -> some View {
        VStack {
            SettingsView()
        }
        .navigationTitle("Settings")
    }
}

extension AppCoordinator {
    func binding<Value>(_ keyPath: ReferenceWritableKeyPath<AppCoordinator, Value>) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
