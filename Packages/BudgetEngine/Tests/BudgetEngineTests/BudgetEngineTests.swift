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
    
    func testExample() {
        XCTAssertTrue(true)
    }
    
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
        let tz = TimeZone(secondsFromGMT: 0)!
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = tz
        
        let now = Date(2025, 10, 15, 12, 0, 0, cal)
        
        let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
        let end = cal.date(byAdding: .month, value: 1, to: start)!
        
        let budget = Budget(
            name: "Test",
            categoryScope: [.food],
            amount: Money(value: 100, currency: .rub),
            periodInterval: .init(start: Date(), end: Date.distantFuture),
            startDate: Date(),
            rolloverRule: .capAtLimit,
            period: .monthly
        )
        
        // Дописать тест
    }
}
