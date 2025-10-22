//
//  Repositories.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import CoreTypes

actor InMemoryTransactionRepository: TransactionRepository {
    private var storage: [TransactionItem] = []
    
    init(initial: [TransactionItem] = []) {
        self.storage = initial
    }
    
    func fetchAll() async -> [TransactionItem] {
        storage
    }
    func add(_ transaction: TransactionItem) async {
        storage.append(transaction)
    }
    func delete(_ transaction: TransactionItem) async {
        storage = storage.filter { $0.id != transaction.id }
    }
    func update(_ transaction: TransactionItem) async {
        print("Update")
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
    func add(_ budget: Budget) async {
        budgets.append(budget)
    }
    func delete(_ budget: Budget) async {
        budgets = budgets.filter { $0.id != budget.id }
    }
    func update(_ budget: Budget) async {
        print("Update")
    }
}
