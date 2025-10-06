//
//  Repositories.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import CoreTypes

protocol TransactionRepository {
    func fetchAll() async -> [TransactionItem]
    func add(_ transaction: TransactionItem) async
    func delete(_ transaction: TransactionItem) async
}

protocol BudgetRepository {
    func fetchAll() async -> [Budget]
}

actor InMemoryTransactionRepository: TransactionRepository {
    private var storage: [TransactionItem] = []
    
    init(initial: [TransactionItem] = []) {
        self.storage = initial
    }
    
    func fetchAll() async -> [TransactionItem] {
        return storage
    }
    func add(_ transaction: TransactionItem) async {
        storage.append(transaction)
    }
    func delete(_ transaction: TransactionItem) async {
        storage = storage.filter { $0.id != transaction.id }
    }
}

actor InMemoryBudgetRepository: BudgetRepository {
    private var budgets: [Budget] = []
    
    init(initial: [Budget] = []) {
        self.budgets = initial
    }
    
    func fetchAll() async -> [Budget] {
        budgets
    }
    func fetchById(by id: UUID) async -> Budget? {
        budgets.first(where: { $0.id == id })
    }
}
