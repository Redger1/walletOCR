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
import VisionOCRKit

enum AppEnvironment {
    case mock, prod
}

@MainActor @Observable
final class AppContainer {
    let transactionRepository: TransactionRepository
    let budgetRepository: BudgetRepository
    
    let budgetCalculator: BudgetCalculator
    
    let environment: AppEnvironment
    
    // Сканирование
    let scanService: ScanService
    let classifier: CategoryClassifying
    
    init(environment: AppEnvironment = .mock) {
        self.environment = environment
        self.budgetCalculator = BudgetCalculator()
        
        // Сканирование
        self.scanService = ScanServiceMock()
        self.classifier = RuleBasedClassifier()
        
        // Добавить в будущем switch environment, когда реализую SwiftDataRepository
        self.transactionRepository = InMemoryTransactionRepository(initial: Fixtures.sampleTransaction())
        self.budgetRepository = InMemoryBudgetRepository(initial: [Fixtures.foodBudget, Fixtures.taxiBudget])
    }
}
