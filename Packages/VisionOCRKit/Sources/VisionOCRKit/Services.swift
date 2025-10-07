//
//  Services.swift
//  VisionOCRKit
//
//  Created by Артем on 07.10.2025.
//
import Foundation
import CoreTypes

public final class ScanServiceMock: ScanService {
    public func scan() async -> OCRDraft {
        OCRDraft(
            date: Date(),
            merchant: "Кофейня",
            total: Money(value: 68, currency: .rub),
            suggestedCategory: .food,
            lineItems: ["Хлеб"],
//            confidence: 0.7,
//            note: "Заметка",
//            paymentMethod: .card
        )
    }
    
    public init() {}
}

public final class RuleBasedClassifier: CategoryClassifying {
    public func classify(_ draft: OCRDraft) -> ClassificationResult {
        let other = ClassificationResult(category: .other, confidence: 0.5)
        guard let merchant = draft.merchant else { return other }
        let merchantLower = merchant.lowercased()
        
        if merchantLower.contains("movie") {
            return ClassificationResult(category: .entertainment, confidence: 0.9)
        }
        if merchantLower.contains("кофе") {
            return ClassificationResult(category: .food, confidence: 0.7)
        } else {
            return other
        }
    }
    
    public init() {}
}
