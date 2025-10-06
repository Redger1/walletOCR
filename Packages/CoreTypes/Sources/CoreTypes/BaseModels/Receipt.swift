//
//  Receipt.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public struct ReceiptItem: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var quantity: Int?
    public var total: Money?
    public var unitPrice: Money?
    public var predictedCategory: CategoryKind?
    
    public init(quantity: Int? = nil, total: Money? = nil, unitPrice: Money? = nil, predictedCategory: CategoryKind? = nil) {
        self.id = UUID()
        self.quantity = quantity
        self.total = total
        self.unitPrice = unitPrice
        self.predictedCategory = predictedCategory
    }
    // Подумать нужно ли это или нет
    // public var computedTotal: Money {}
}

public struct Receipt: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var images: [AttachmentRef]?
    public var ocrText: String?
    public var ocrConfidence: Double?
    public var total: Money?
    public var items: [ReceiptItem]?
    public var linkedTransactionIds: [TransactionItem.ID]?
    
    public init(ocrText: String? = nil, ocrConfidence: Double? = nil, total: Money? = nil, items: [ReceiptItem]? = nil, linkedTransactionIds: [TransactionItem.ID]? = nil) {
        self.id = UUID()
        self.ocrText = ocrText
        self.ocrConfidence = ocrConfidence
        self.total = total
        self.items = items
        self.linkedTransactionIds = linkedTransactionIds
    }
}
