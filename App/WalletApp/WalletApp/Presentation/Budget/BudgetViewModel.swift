//
//  BudgetViewModel.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import CoreTypes
import BudgetEngine

@MainActor @Observable
final class BudgetViewModel {
    private var calculator: BudgetCalculatorProtocol
    private var budgetRepository: BudgetRepository
    private var transactionRepository: TransactionRepository
    
    var currentBudgetId: UUID? {
        didSet { self.updateBudgetSnapshot() }
    }
    var transactions: [TransactionItem] = []
    var snapshot: BudgetSnapshot?
    var budgets: [Budget] = []
    
    init(
        transactionRepository: TransactionRepository,
        budgetRepository: BudgetRepository,
        calculator: BudgetCalculatorProtocol = BudgetCalculator()
    ) {
        self.calculator = calculator
        self.budgetRepository = budgetRepository
        self.transactionRepository = transactionRepository
    }
    
    func load() async {
        budgets = await budgetRepository.fetchAll()
        if currentBudgetId == nil { currentBudgetId = budgets.first?.id }
        transactions = await transactionRepository.fetchAll()
        updateBudgetSnapshot()
    }
    
    func updateBudgetSnapshot() {
        guard let budget = budgets.first(where: { $0.id == currentBudgetId }) else { snapshot = nil; return }
        snapshot = calculator.snapshot(for: budget, transactions: transactions, now: Date())
    }
    
    func addTransaction(_ newTransaction: TransactionItem) async {
        await transactionRepository.add(newTransaction)
        await load()
    }
    
    func deleteTransaction(_ deleteItem: TransactionItem) async {
        await transactionRepository.delete(deleteItem)
        await load()
    }
    
    func addBudget(_ budget: Budget) async {
        await budgetRepository.add(budget)
        await load()
    }
    
    func updateBudget(_ budget: Budget) async {
        await budgetRepository.update(budget)
        await load()
    }
    
    func selectBudget(_ id: UUID) { currentBudgetId = id }
    
    func deleteBudget(_ budget: Budget) async {
        await budgetRepository.delete(budget)
        await load()
    }
    
    var filteredTransactions: [TransactionItem] {
        guard let s = snapshot, let budget = budgets.first(where: { $0.id == currentBudgetId }) else { return [] }
        return transactions.filter { tx in
            s.period.contains(tx.date) &&
            (budget.categoryScope.contains(tx.categoryKind) || budget.categoryScope.isEmpty)
        }
        .sorted { $0.date > $1.date }
    }
    
    func budgetCategories(_ budget: Budget) -> String {
        if budget.categoryScope.isEmpty { return "All categories" }
        return budget.categoryScope
            .map { $0.title }
            .sorted()
            .joined(separator: ", ")
    }
}
