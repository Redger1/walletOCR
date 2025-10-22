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
    
    public func add(_ budget: Budget) async {
        do {
            let dto = SDBudget()
            budget.fillDTO(dto)
            context.insert(dto)
            try context.save()
        } catch {
            print("SwiftData add budget failed: \(error)")
        }
    }
    
    public func delete(_ budget: Budget) async {
        do {
            let pred = #Predicate<SDBudget> { $0.id == budget.id }
            if let dto = try context.fetch(FetchDescriptor<SDBudget>(predicate: pred)).first {
                context.delete(dto)
                try context.save()
            }
        } catch {
            print("SwiftData delete budget failed: \(error)")
        }
    }
    
    public func update(_ budget: Budget) async {
        do {
            let pred = #Predicate<SDBudget> { $0.id == budget.id }
            if let dto = try context.fetch(FetchDescriptor<SDBudget>(predicate: pred)).first {
                dto.id = budget.id
                dto.name = budget.name
                dto.periodRaw = budget.period.rawValue
                dto.amountCurrency = budget.amount.currency.code
                dto.amountValue = NSDecimalNumber(decimal: budget.amount.value).doubleValue
                dto.amountCurrencySymbol = budget.amount.currency.symbol
                dto.categoryScopeRaw = budget.categoryScope.map { $0.rawValue }
                dto.rolloverRuleRaw = budget.rolloverRule.rawValue
                dto.startDate = budget.startDate
                
                try context.save()
            } else {
                print("Cant find budget with id \(budget.id)")
            }
        } catch{
            print("SwiftData update budget failed: \(error)")
        }
    }
}
