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
            date: date,
            categoryKind: cat,
            total: Money(value: Decimal(totalValue), currency: Currency(code: totalCurrency, symbol: "р")),
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
//    func toDTO(in context: ModelContext) -> SDTransaction {
//        let dto = SDTransaction(context: context)
//        dto.id = id
//        dto.date = date
//        dto.totalValue = NSDecimalNumber(decimal: total.value).doubleValue
//        dto.totalCurrency = total.currency.code
//        dto.categoryRaw = categoryKind.rawValue
//        dto.merchant = merchant
//        dto.paymentMethodRaw = (paymentMethod ?? .other).rawValue
//        dto.statusRaw = (status ?? .pending).rawValue
//        dto.note = note
//        return dto
//    }
}

extension SDBudget {
    func toDomain() -> Budget {
        var categoriesSet = Set<CategoryKind>()
        for categoryRaw in categoryScopeRaw {
            categoriesSet.insert(CategoryKind(rawValue: categoryRaw)!)
        }
        
        return Budget(
            name: name,
            categoryScope: categoriesSet,
            amount: Money(value: Decimal(amountValue), currency: Currency(code: amountCurrency, symbol: amountCurrencySymbol)),
            periodInterval: DateIntervalEx(start: periodStart!, end: periodEnd!),
            startDate: startDate,
            rolloverRule: RolloverRule(rawValue: rolloverRuleRaw)!,
            period: Period(rawValue: periodRaw)!
        )
    }
}
extension Budget {
    func toDTO() -> SDBudget {
        SDBudget(
            id: id,
            name: name,
            categoryScopeRaw: categoryScope.map {$0.title},
            amountValue: NSDecimalNumber(decimal: amount.value).doubleValue,
            amountCurrency: amount.currency.code,
            amountCurrencySymbol: amount.currency.symbol,
            periodStart: periodInterval?.start,
            periodEnd: periodInterval?.end,
            startDate: startDate,
            rolloverRuleRaw: rolloverRule.title,
            periodRaw: period.title
        )
    }
}
