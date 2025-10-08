//
//  BudgetEngineTests.swift
//  
//
//  Created by Артем on 01.10.2025.
//
import XCTest
@testable import BudgetEngine
import CoreTypes

final class BudgetEngineTests: XCTestCase {
    let calculator = BudgetCalculator()
    
    func testEmptyTransactions() {
        let budget = Budget(
            name: "Test budget",
            categoryScope: [.entertainment],
            amount: Money(value: 100, currency: .rub),
            periodInterval: .init(start: Date(), end: Date.distantFuture),
            startDate: Date(),
            rolloverRule: .capAtLimit,
            period: .monthly
        )
        
        let snapshot = calculator.snapshot(for: budget, transactions: [])
        
        XCTAssertTrue(snapshot.planned == snapshot.remaining)
        XCTAssertEqual(snapshot.spent.value, 0)
    }
    
    func testNoCategoryMatch() {
        let transaction = TransactionItem(date: Date(), categoryKind: .entertainment, total: Money(value: 10, currency: .rub))
        let budget = Budget(
            name: "Test budget",
            categoryScope: [.food],
            amount: Money(value: 100, currency: .rub),
            periodInterval: .init(start: Date(), end: Date.distantFuture),
            startDate: Date(),
            rolloverRule: .capAtLimit,
            period: .monthly
        )
        
        let snapshot = calculator.snapshot(for: budget, transactions: [transaction])
        XCTAssertTrue(snapshot.progress.isZero)
        XCTAssertEqual(snapshot.spent.value, 0)
        XCTAssertEqual(snapshot.remaining, snapshot.planned)
    }
    
    func testLimitOverflow() {
        let transaction = TransactionItem(date: Date(), categoryKind: .food, total: Money(value: 1000, currency: .rub))
        let budget = Budget(
            name: "Test budget",
            categoryScope: [.food],
            amount: Money(value: 100, currency: .rub),
            periodInterval: .init(start: Date(), end: Date.distantFuture),
            startDate: Date(),
            rolloverRule: .capAtLimit,
            period: .monthly
        )
        
        let snapshot = calculator.snapshot(for: budget, transactions: [transaction])
        XCTAssertEqual(snapshot.remaining.value, 0)
        XCTAssertEqual(snapshot.progress, 1)
    }
    
    func test_Period_IncludesStart_ExcludesEnd() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = date(2025, 10, 15, 12, 0, 0, cal)
        
        let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
        let end = cal.date(byAdding: .month, value: 1, to: start)!
        
        let budget = Budget(
            name: "Test",
            categoryScope: [.food],
            amount: Money(value: 10_000, currency: .rub),
            periodInterval: .init(start: Date(), end: Date.distantFuture),
            startDate: Date(),
            rolloverRule: .capAtLimit,
            period: .monthly
        )
        
        let txAtStart = self.tx(amount: 100, date: start)                            // Войдет
        let txBeforeStart = self.tx(amount: 200, date: start.addingTimeInterval(-1)) // Не войдет
        let txBeforeEnd = self.tx(amount: 300, date: end.addingTimeInterval(-1))     // Войдет
        let txAtEnd = self.tx(amount: 400, date: end)                                // Не войдет
        let txAfterEnd = self.tx(amount: 500, date: end.addingTimeInterval(1))       // Не войдет
        
        let all = [txAtStart, txBeforeStart, txBeforeEnd, txAtEnd, txAfterEnd]
        
        let snapshot = calculator.snapshot(for: budget, transactions: all, now: now)
        
        XCTAssertEqual(snapshot.spent.value, Decimal(400))
        XCTAssertEqual(snapshot.planned.value, Decimal(10_000))
        
        XCTAssertEqual(snapshot.period.start, start)
        XCTAssertEqual(snapshot.period.end, end)
        
        XCTAssertTrue(snapshot.period.contains(txAtStart.date))
        XCTAssertTrue(snapshot.period.contains(txBeforeEnd.date))
        XCTAssertFalse(snapshot.period.contains(txAtEnd.date))
    }
    
    // Helpers
    private func tx(amount: Decimal, date: Date) -> TransactionItem {
        TransactionItem(
            date: date,
            categoryKind: .food,
            total: Money(value: amount, currency: .rub)
        )
    }
    
    private func date(_ y: Int, _ m: Int, _ d: Int, _ hh: Int, _ mm: Int, _ ss:Int, _ cal: Calendar) -> Date {
        cal.date(from: DateComponents(timeZone: cal.timeZone, year: y, month: m, day: d, hour: hh, minute: mm, second: ss))!
    }
}
