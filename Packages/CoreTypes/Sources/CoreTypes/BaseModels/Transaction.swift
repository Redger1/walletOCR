//
//  Transaction.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public enum PaymentMethod: String, Hashable, Sendable, Codable, CaseIterable {
    case card
    case cash
    case transfer
    case other
    
    public var title: String {
        switch self {
            case .card: "Card"
            case .cash: "Cash"
            case .transfer: "Transfer"
            case .other: "Other"
        }
    }
}

public enum TransactionStatus: String, Sendable, Hashable, Codable, CaseIterable {
    case pending
    case posted
    case corrected
    case deleted
    
    public var title: String {
        switch self {
            case .pending: "Draft"
            case .posted: "Done"
            case .corrected: "Edited"
            case .deleted: "Deleted"
        }
    }
}

public enum TransactionPeriodFilter: String, CaseIterable, Identifiable {
    case all
    case currentMonth
    case lastWeek
    
    public var id: Self { self }
    
    public var title: String {
        switch self {
            case .all: "All"
            case .currentMonth: "Current month"
            case .lastWeek: "Last week"
        }
    }
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
        id: UUID = UUID(),
        date: Date,
        categoryKind: CategoryKind,
        receiptID: Receipt.ID? = nil,
        merchant: String? = nil,
        total: Money,
        paymentMethod: PaymentMethod? = nil,
        status: TransactionStatus? = nil,
        note: String? = nil
    ) {
        self.id = id
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
