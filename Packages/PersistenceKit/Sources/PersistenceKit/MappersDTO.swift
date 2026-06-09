//
//  MappersDTO.swift
//  PersistenceKit
//
//  Created by Артем on 08.10.2025.
//
import CoreTypes
import SwiftData
import Foundation

// Убрать force unrwap везде
// Написать тесты и проверить с nil значениями
extension SDTransaction {
    func toDomain() -> TransactionItem {
        let cat = CategoryKind(rawValue: categoryRaw) ?? .other
        let pm = paymentMethodRaw.flatMap(PaymentMethod.init(rawValue:)) ?? .other
        let st = statusRaw.flatMap(TransactionStatus.init(rawValue:)) ?? .pending
 
        return TransactionItem(
            id: id,
            date: date,
            categoryKind: cat,
            merchant: merchant,
            total: Money(value: Decimal(totalValue), currency: Currency(code: totalCurrency, symbol: "₽")),
            paymentMethod: pm,
            status: st,
            note: note
        )
    }
}
extension TransactionItem {
    func fillDTO(_ dto: SDTransaction) {
        dto.id = id
        dto.date = date
        dto.totalValue = NSDecimalNumber(decimal: total.value).doubleValue
        dto.totalCurrency = total.currency.code
        dto.categoryRaw = categoryKind.rawValue
        dto.merchant = merchant
        dto.paymentMethodRaw = (paymentMethod ?? .other).rawValue
        dto.statusRaw = (status ?? .pending).rawValue
        dto.note = note
    }
}

extension SDBudget {
    func toDomain() -> Budget {
        let categories = Set(categoryScopeRaw.flatMap { CategoryKind(rawValue: $0) ?? .other })
        
        return Budget(
            id: id,
            name: name,
            categoryScope: categories,
            amount: Money(value: Decimal(amountValue), currency: Currency(code: amountCurrency, symbol: amountCurrencySymbol)),
            periodInterval: DateIntervalEx(start: periodStart ?? .now, end: periodEnd ?? .now),
            startDate: startDate,
            rolloverRule: RolloverRule(rawValue: rolloverRuleRaw) ?? .capAtLimit,
            period: Period(rawValue: periodRaw) ?? .monthly
        )
    }
}
extension Budget {
    func fillDTO(_ dto: SDBudget) {
        dto.id = id
        dto.name = name
        dto.amountCurrency = amount.currency.code
        dto.amountValue = NSDecimalNumber(decimal: amount.value).doubleValue
        dto.amountCurrencySymbol = amount.currency.symbol
        dto.categoryScopeRaw = categoryScope.map { $0.rawValue }
        dto.rolloverRuleRaw = rolloverRule.rawValue
        dto.periodRaw = period.rawValue
        dto.startDate = startDate
    }
}
