//
//  PersistenceKitTests.swift
//
//
//  Created by Артем on 01.10.2025.
//
import XCTest
import SwiftData
import Foundation
@testable import PersistenceKit
@testable import CoreTypes

@MainActor
final class PersistenceKitTests: XCTestCase {
    //    var repo: SwiftDataTransactionRepository!
    //    var context: ModelContext!
    //
    //    override func setUp() async throws {
    //        let cfg = ModelConfiguration(isStoredInMemoryOnly: true)
    //        let container = try ModelContainer(for: SDTransaction.self, configurations: cfg)
    //        repo = SwiftDataTransactionRepository(context: container.mainContext)
    //        context = container.mainContext
    //    }
    
    func test_add_fetch_delete() async {
        do {
            let cfg = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: SDTransactionV2.self, configurations: cfg)
            let ctx = container.mainContext
            
            let dto = SDTransactionV2()
            dto.id = UUID()
            dto.date = Date.now
            dto.totalValue = 100
            dto.totalCurrency = "EUR"
            dto.categoryRaw = "other"
            dto.merchant = nil
            dto.note = nil
            dto.paymentMethodRaw = nil
            dto.statusRaw = nil
            
            ctx.insert(dto)
            try ctx.save()
            let rows = try ctx.fetch(FetchDescriptor<SDTransactionV2>())
            XCTAssertEqual(rows.count, 1)
            _ = rows[0].id
            _ = rows[0].date
            _ = rows[0].totalValue
            _ = rows[0].totalCurrency
            _ = rows[0].categoryRaw
            _ = rows[0].merchant
            _ = rows[0].note
            _ = rows[0].statusRaw
            _ = rows[0].paymentMethodRaw
        } catch {
            print("ERROR")
        }
    }
}
