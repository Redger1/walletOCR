//
//  SwiftDataBudgetRepository.swift.swift
//  PersistenceKit
//
//  Created by Артем on 08.10.2025.
//
import CoreTypes
import SwiftData
import Foundation

// Дописать CRUD, возможно изменить протокол BudgetRepository

@MainActor
public final class SwiftDataBudgetRepository: BudgetRepository {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }
    
    public func fetchAll() async -> [Budget] {
        let desc = FetchDescriptor<SDBudget>(sortBy: [SortDescriptor(\.periodStart, order: .forward)])
        let rows = (try? context.fetch(desc)) ?? []
        return rows.map { $0.toDomain() }
    }
}
