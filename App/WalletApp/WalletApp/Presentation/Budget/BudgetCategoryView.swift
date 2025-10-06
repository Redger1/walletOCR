//
//  BudgetCategoryView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import Foundation
import SwiftUI

struct BudgetCategoryView: View {
    var id: UUID
    var goBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Category: \(id.uuidString)")
            Button("Go back") { goBack() }
        }
    }
}
