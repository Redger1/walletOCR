//
//  Budget.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

// Что делать с остатком в следующем периоде
public enum RolloverRule: String, Codable, Hashable, Sendable {
    case none
    case carryOver
    case capAtLimit
}

// В будущем расширить периоды - неделя, день, год и тд
public enum Period: String, Codable, Hashable, Sendable {
    case monthly
}

public struct Budget: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var name: String
    public var categoryScope: Set<CategoryKind>
    public var amount: Money
    public var periodInterval: DateIntervalEx?
    public var startDate: Date
    public var rolloverRule: RolloverRule
    public var period: Period = .monthly
    
    public init(name: String, categoryScope: Set<CategoryKind>, amount: Money, periodInterval: DateIntervalEx? = nil, startDate: Date, rolloverRule: RolloverRule, period: Period = .monthly) {
        self.id = UUID()
        self.name = name
        self.categoryScope = categoryScope
        self.amount = amount
        self.periodInterval = periodInterval
        self.startDate = startDate
        self.rolloverRule = rolloverRule
        self.period = period
    }
}

public struct BudgetSnapshot: Hashable, Codable, Sendable {
    public var period: DateIntervalEx
    public var planned: Money
    public var spent: Money
    public var remaining: Money
    public var progress: Decimal
    
    public init(period: DateIntervalEx, planned: Money, spent: Money, remaining: Money, progress: Decimal) {
        self.period = period
        self.planned = planned
        self.spent = spent
        self.remaining = remaining
        self.progress = progress
    }
}
