//
//  Transaction.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public enum PaymentMethod: String, Hashable, Sendable, Codable, CaseIterable {
    case card = "Карта"
    case cash = "Наличные"
    case transfer = "Перевод"
    case other = "Другое"
    
    public var title: String { self.rawValue }
}

public enum TransactionStatus: String, Sendable, Hashable, Codable, CaseIterable {
    case pending = "Черновик"   // черновик
    case posted = "Готово"    // готовая
    case corrected = "Отредактирован" // исправлен
    case deleted = "Удален"   // помечена как удаленная
    
    public var title: String { self.rawValue }
}

public struct TransactionItem: Identifiable, Hashable, Sendable, Codable {
    public let id: UUID
    public var date: Date
    public var total: Money
    public var categoryKind: CategoryKind
    public var receiptID: Receipt.ID?
    public var merchant: String?
    public var paymentMethod: PaymentMethod?
    public var status: TransactionStatus?
    public var note: String?
    
    public init(
        date: Date,
        categoryKind: CategoryKind,
        receiptID: Receipt.ID? = nil,
        merchant: String? = nil,
        total: Money,
        paymentMethod: PaymentMethod? = nil,
        status: TransactionStatus? = nil,
        note: String? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.categoryKind = categoryKind
        self.receiptID = receiptID
        self.merchant = merchant
        self.total = total
        self.paymentMethod = paymentMethod
        self.status = status
        self.note = note
    }
    
    public init(date: Date, categoryKind: CategoryKind, total: Money, paymentMethod: PaymentMethod, note: String) {
        self.id = UUID()
        self.date = date
        self.categoryKind = categoryKind
        self.total = total
        self.paymentMethod = paymentMethod
        self.note = note
    }
}
