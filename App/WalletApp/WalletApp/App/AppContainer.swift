//
//  AppContainer.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import SwiftUI
import CoreTypes
import BudgetEngine
import Observation

enum AppEnvironment {
    case mock, prod
}

@MainActor @Observable
final class AppContainer {
    let transactionRepository: TransactionRepository
    let budgetRepository: BudgetRepository
    
    let budgetCalculator: BudgetCalculator
    
    let environment: AppEnvironment
    
    init(environment: AppEnvironment = .mock) {
        self.environment = environment
        self.budgetCalculator = BudgetCalculator()
        
        // Добавить в будущем switch environment, когда реализую SwiftDataRepository
        self.transactionRepository = InMemoryTransactionRepository(initial: Fixtures.sampleTransaction())
        self.budgetRepository = InMemoryBudgetRepository(initial: [Fixtures.foodBudget, Fixtures.taxiBudget])
    }
}
