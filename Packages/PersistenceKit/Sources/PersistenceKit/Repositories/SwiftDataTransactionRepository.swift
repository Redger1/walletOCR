//
//  PersistenceKit.swift
//  
//
//  Created by Артем on 01.10.2025.
//
import CoreTypes
import SwiftData
import Foundation

// Переписать репозиторий, сейчас он падает при любом действии с моделью
@MainActor
public final class SwiftDataTransactionRepository: TransactionRepository {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }
    
    public func fetchAll() async -> [TransactionItem] {
        do {
            let rows = try context.fetch(FetchDescriptor<SDTransaction>())
            return rows.map { $0.toDomain() }
        } catch {
            assertionFailure("SwiftData fetch failed: \(error)")
            return []
        }
    }
    
    public func add(_ transaction: TransactionItem) async {
        do {
            let dto = SDTransaction()
            transaction.fillDTO(dto)
            try context.save()
        } catch {
            assertionFailure("SwiftData add failed: \(error)")
        }
    }
    
    public func delete(_ transaction: TransactionItem) async {
        do {
            let pred = #Predicate<SDTransaction> { $0.id == transaction.id }
            if let dto = try context.fetch(FetchDescriptor<SDTransaction>(predicate: pred)).first {
                context.delete(dto)
                try context.save()
            }
        } catch {
            assertionFailure("SwiftData delete failed: \(error)")
        }
    }
}
