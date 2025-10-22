//
//  TransactionViewModel.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import Foundation
import Observation
import CoreTypes

@Observable @MainActor
final class TransactionViewModel {
    private var transactionRepository: TransactionRepository
    var transactions: [TransactionItem] = []
    
    init(transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
    }
    
    func load() async {
        self.transactions = await transactionRepository.fetchAll()
    }
    
    func addTransaction(_ transaction: TransactionItem) async {
        await transactionRepository.add(transaction)
        await load()
    }
    
    func deleteTransaction(_ transaction: TransactionItem) async {
        await transactionRepository.delete(transaction)
        await load()
    }
    
    func updateTransaction(_ transaction: TransactionItem) async {
        await transactionRepository.update(transaction)
        await load()
    }
    
    var sortedTransactions: [TransactionItem] { transactions.sorted { $0.date > $1.date } }
    
    var totalSpentMoney: Decimal {
        transactions.reduce(0, { accum, transaction in
            return accum + transaction.total.value
        })
    }
}
