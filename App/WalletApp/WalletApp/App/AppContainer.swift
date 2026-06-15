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
import SwiftData
import PersistenceKit

enum AppEnvironment {
    case mock, prod
}

@MainActor @Observable
final class AppContainer {
    let transactionRepository: TransactionRepository
    let budgetRepository: BudgetRepository
    let budgetCalculator: BudgetCalculator
    let environment: AppEnvironment
    let csvExportService: CSVExportServiceProtocol
    
    // Сканирование
    let scanService: ScanService
    let classifier: CategoryClassifying
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init(environment: AppEnvironment = .mock) {
        self.environment = environment
        self.budgetCalculator = BudgetCalculator()
        self.csvExportService = CSVExportService()
        
        // Сканирование
        self.scanService = ScanServiceMock()
        self.classifier = RuleBasedClassifier()
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        // Подумать, можно ли (и нужно ли) убрать force unwrap
        switch environment {
            case .mock:
                self.modelContainer = try! ModelContainer(for: SDBudget.self, SDTransaction.self, configurations: config)
                self.modelContext = modelContainer.mainContext
                migrateLegacyEnumsIfNeeded(context: modelContext)
                
                self.transactionRepository = InMemoryTransactionRepository(initial: Fixtures.sampleTransaction())
                self.budgetRepository      = InMemoryBudgetRepository(initial: [Fixtures.foodBudget, Fixtures.taxiBudget])
            case .prod:
                self.modelContainer = try! ModelContainer(for: SDBudget.self, SDTransaction.self)
                self.modelContext = modelContainer.mainContext
                migrateLegacyEnumsIfNeeded(context: modelContext)
                    
                self.transactionRepository = SwiftDataTransactionRepository(context: modelContext)
                self.budgetRepository      = SwiftDataBudgetRepository(context: modelContext)
        }
    }
}
