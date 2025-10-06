//
//  Fixtures.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
#if DEBUG
import Foundation
import CoreTypes

enum Fixtures {
    static let rub = Currency(code: "RUB", symbol: "₽")
    
    static let foodBudget = Budget(
        name: "Еда+здоровье",
        categoryScope: [.food, .health],
        amount: Money(value: 20_000, currency: rub),
        startDate: Date(),
        rolloverRule: .none
    )
    
    static let taxiBudget = Budget(
        name: "Еда",
        categoryScope: [.food],
        amount: Money(value: 3_000, currency: rub),
        startDate: Date(),
        rolloverRule: .capAtLimit
    )
    
    static func makeRandomTransaction() -> TransactionItem {
        return TransactionItem(
            date: Date(),
            categoryKind: .food,
            total: Money(value: 2000, currency: .rub),
            paymentMethod: .cash,
            note: "Some random note"
        )
    }
    
    static func sampleTransaction(now: Date = .now) -> [TransactionItem] {
        return [
            TransactionItem(
                date: Calendar.current.date(byAdding: .day, value: -5, to: now)!,
                categoryKind: .food,
                total: Money(value: 10_000, currency: rub),
                paymentMethod: .card,
                note: "Note 1"
            ),
            TransactionItem(
                date: Calendar.current.date(byAdding: .day, value: -2, to: now)!,
                categoryKind: .food,
                total: Money(value: 15_000, currency: rub),
                paymentMethod: .transfer,
                note: "Note 2"
            ),
            TransactionItem(
                date: Calendar.current.date(byAdding: .day, value: -1, to: now)!,
                categoryKind: .transfer,
                total: Money(value: 5_000, currency: rub),
                paymentMethod: .cash,
                note: "Note 3"
            ),
        ]
    }
}
#endif
