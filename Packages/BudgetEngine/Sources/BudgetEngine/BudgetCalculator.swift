//
//  BudgetCalculator.swift
//  BudgetEngine
//
//  Created by Артем on 01.10.2025.
//
import Foundation
import CoreTypes

public struct BudgetCalculator {
    public func snapshot(for budget: Budget, transactions: [TransactionItem]) -> BudgetSnapshot {
    
        return BudgetSnapshot(
            period: DateIntervalEx(start: .now, end: .now),
            planned: budget.amount,
            spent: <#T##Money#>,
            remaining: <#T##Money#>,
            progress: <#T##Double#>
        )
    }
}
