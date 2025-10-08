//
//  Migrations.swift
//  PersistenceKit
//
//  Created by Артем on 08.10.2025.
//
import SwiftData
import CoreTypes

@MainActor
public func migrateLegacyEnumsIfNeeded(context: ModelContext) {
    let rows = (try? context.fetch(FetchDescriptor<SDTransaction>())) ?? []
    var changed = 0
    
    for dto in rows {
        dto.paymentMethodRaw = canonicalizePayment(dto.paymentMethodRaw)
        dto.statusRaw = canonicalizeStatus(dto.statusRaw)
        dto.categoryRaw = canonicalizeCategory(dto.categoryRaw)
        changed += 1
    }
    
    if changed > 0 {
        try? context.save()
        print("Migration done: \(changed) records sanitized")
    }
}

public func canonicalizePayment(_ s: String?) -> String? {
    switch s {
        case "Карта": return PaymentMethod.card.rawValue
        case "Наличные": return PaymentMethod.cash.rawValue
        case "Перевод": return PaymentMethod.transfer.rawValue
        case "Другое": return PaymentMethod.other.rawValue
        default: return s
    }
}

public func canonicalizeStatus(_ s: String?) -> String? {
    switch s {
        case "Готово": return TransactionStatus.posted.rawValue
        case "Черновик": return TransactionStatus.pending.rawValue
        case "Отредактирован": return TransactionStatus.corrected.rawValue
        case "Удален": return TransactionStatus.deleted.rawValue
        default: return s
    }
}

public func canonicalizeCategory(_ s: String) -> String {
    switch s {
        case "Еда": return CategoryKind.food.rawValue
        case "Перевод": return CategoryKind.transfer.rawValue
        case "Здоровье": return CategoryKind.health.rawValue
        case "Развлечения": return CategoryKind.entertainment.rawValue
        case "Другое": return CategoryKind.other.rawValue
        default: return s
    }
}
