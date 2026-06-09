//
//  BudgetSelector.swift
//  WalletApp
//
//  Created by Артем on 20.10.2025.
//
import SwiftUI
import CoreTypes

struct BudgetSelector: View {
    var viewModel: BudgetViewModel
    
    var allItemBackground: Color {
        viewModel.currentBudgetId == nil ? Color.indigo : Color(UIColor.secondarySystemBackground)
    }
    func itemBackground(for budget: Budget) -> Color {
        viewModel.currentBudgetId == budget.id ? Color.indigo : Color(UIColor.secondarySystemBackground)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.budgets, id: \.self) { budget in
                    Button { viewModel.currentBudgetId = budget.id }
                    label: { Text(budget.name).font(.callout) }
                        .padding(8)
                        .background(itemBackground(for: budget))
                        .foregroundStyle(viewModel.currentBudgetId == budget.id ? Color.white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .buttonStyle(.plain)
                }
            }
        }
    }
}
