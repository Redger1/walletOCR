//
//  VisionORCKit.swift
//  
//
//  Created by Артем on 01.10.2025.
//
import Foundation
import CoreTypes

public struct OCRDraft: Codable, Sendable, Hashable, Identifiable {
    public let id: UUID = UUID()
    public var date: Date?
    public var merchant: String?
    public var total: Money?
    public var suggestedCategory: CategoryKind
    public var lineItems: [String] = []
    public var confidence: Double?
    public var note: String?
    public var paymentMethod: PaymentMethod?
    
    init(date: Date? = nil, merchant: String? = nil, total: Money? = nil, suggestedCategory: CategoryKind, lineItems: [String], confidence: Double? = nil, note: String? = nil, paymentMethod: PaymentMethod? = nil) {
        self.date = date
        self.merchant = merchant
        self.total = total
        self.suggestedCategory = suggestedCategory
        self.lineItems = lineItems
        self.confidence = confidence
        self.note = note
        self.paymentMethod = paymentMethod
    }
}

public struct ClassificationResult {
    public let id = UUID()
    public var category: CategoryKind
    public var confidence: Double
    public var alternatives: [(CategoryKind, Double)]?
}

public protocol ScanService {
    func scan() async -> OCRDraft
}

public protocol CategoryClassifying {
    func classify(_ draft: OCRDraft) -> ClassificationResult
}
