//
//  Repositories.swift
//  CoreTypes
//
//  Created by Артем on 08.10.2025.
//
public protocol TransactionRepository {
    func fetchAll() async -> [TransactionItem]
    func add(_ transaction: TransactionItem) async
    func delete(_ transaction: TransactionItem) async
}

public protocol BudgetRepository {
    func fetchAll() async -> [Budget]
}
