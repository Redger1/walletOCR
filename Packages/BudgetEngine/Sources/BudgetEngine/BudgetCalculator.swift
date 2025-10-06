//
//  BudgetCalculator.swift
//  BudgetEngine
//
//  Created by Артем on 01.10.2025.
//
import Foundation
import CoreTypes

public protocol BudgetCalculatorProtocol {
    func snapshot(for budget: Budget, transactions: [TransactionItem], now: Date) -> BudgetSnapshot
}

public struct BudgetCalculator: BudgetCalculatorProtocol {
    public init() {}
    
    public func snapshot(for budget: Budget, transactions: [TransactionItem], now: Date = Date()) -> BudgetSnapshot {
        let period = makePeriodInterval(budget: budget, now: now)
        
        let relevantTransactions = transactions.filter {
            period.contains($0.date) && (budget.categoryScope.contains($0.categoryKind) || budget.categoryScope.isEmpty)
        }
        let spentValue = relevantTransactions.reduce(Decimal(0), { x, y in
            return x + y.total.value
        })
        
        let remaining = max(budget.amount.value - spentValue, 0)
        let progress = budget.amount.value == 0 ? 0 : min(spentValue / budget.amount.value, 1)
        
        return BudgetSnapshot(
            period: period,
            planned: budget.amount,
            spent: Money(value: spentValue, currency: budget.amount.currency),
            remaining: Money(value: remaining, currency: budget.amount.currency),
            progress: progress
        )
    }
    
    private func makePeriodInterval(budget: Budget, now: Date) -> DateIntervalEx {
        let cal = Calendar.current
        
        switch budget.period {
            case .monthly:
                let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
                let end = cal.date(byAdding: .month, value: 1, to: start)!
                return DateIntervalEx(start: start, end: end)
        }
    }
}
