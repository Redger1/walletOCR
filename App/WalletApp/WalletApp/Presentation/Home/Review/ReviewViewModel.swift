//
//  ReviewViewModel.swift
//  WalletApp
//
//  Created by Артем on 07.10.2025.
//
import Foundation
import Observation
import CoreTypes
import VisionOCRKit

@MainActor @Observable
final class ReviewViewModel {
    var draft: OCRDraft
    var classifier: CategoryClassifying
    var transactionRepo: TransactionRepository
    
    var suggestedCategorySnapshot: CategoryKind?
    var suggestedConfidenceSnapshot: Double?
    
    init(draft: OCRDraft, classifier: CategoryClassifying, transactionRepo: TransactionRepository) {
        self.draft = draft
        self.classifier = classifier
        self.transactionRepo = transactionRepo
        tryToClassify()
    }
    
    private func tryToClassify() {
        let classificationResult = classifier.classify(draft)
        draft.confidence = classificationResult.confidence
        draft.suggestedCategory = classificationResult.category
        
        self.suggestedCategorySnapshot = classificationResult.category
        self.suggestedConfidenceSnapshot = classificationResult.confidence
    }
}
