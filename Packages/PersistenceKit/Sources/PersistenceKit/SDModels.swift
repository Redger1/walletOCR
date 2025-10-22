//
//  SDModels.swift
//  PersistenceKit
//
//  Created by Артем on 08.10.2025.
//
import SwiftData
import Foundation

// Тестовая модель
//@Model
//public final class SDTransactionV2 {
//    public var id: UUID = UUID()
//    public var date: Date = Date.now
//    public var totalValue: Double = 0
//    public var totalCurrency: String = "RUB"
//    public var categoryRaw: String = "other"
//    var merchant: String? = nil
//    var paymentMethodRaw: String? = nil
//    var statusRaw: String? = nil
//    var note: String? = nil
//    
//    init() {}
//}

@Model
public final class SDTransaction {
    @Attribute(.unique) public var id: UUID = UUID()
    var date: Date = Date.now
    var totalValue: Double = 0
    var totalCurrency: String = "RUB"
    var categoryRaw: String = "other"
    var merchant: String? = nil
    var paymentMethodRaw: String? = nil
    var statusRaw: String? = nil
    var note: String? = nil
    
    init() {}
}

@Model
public final class SDBudget {
    @Attribute(.unique) public var id: UUID = UUID()
    var name: String = ""
    var categoryScopeRaw: [String] = []
    var amountValue: Double = 0
    var amountCurrency: String = ""
    var amountCurrencySymbol: String = ""
    var periodStart: Date? = nil
    var periodEnd: Date? = nil
    var startDate: Date = Date.now
    var rolloverRuleRaw: String = ""
    var periodRaw: String = ""
    
    init() {}
    
//    public init(id: UUID, name: String, categoryScopeRaw: [String], amountValue: Double, amountCurrency: String, amountCurrencySymbol: String,
//                periodStart: Date?, periodEnd: Date?, startDate: Date, rolloverRuleRaw: String, periodRaw: String) {
//        self.id = id
//        self.name = name
//        self.categoryScopeRaw = categoryScopeRaw
//        self.amountValue = amountValue
//        self.amountCurrency = amountCurrency
//        self.amountCurrencySymbol = amountCurrencySymbol
//        self.periodStart = periodStart
//        self.periodEnd = periodEnd
//        self.startDate = startDate
//        self.rolloverRuleRaw = rolloverRuleRaw
//        self.periodRaw = periodRaw
//    }
}
