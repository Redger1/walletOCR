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
    @Binding var showModal: Bool
    @Binding var editableBudget: Budget?
    
    var allItemBackground: Color {
        viewModel.currentBudgetId == nil ? Color.indigo : Color(UIColor.secondarySystemBackground)
    }
    func itemBackground(for budget: Budget) -> Color {
        viewModel.currentBudgetId == budget.id ? Color.indigo : Color(UIColor.secondarySystemBackground)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button { viewModel.currentBudgetId = nil }
                label: { Text("Все").font(.callout) }
                    .padding(8)
                    .background(allItemBackground)
                    .foregroundStyle(viewModel.currentBudgetId == nil ? Color.white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .buttonStyle(.plain)
                
                ForEach(viewModel.budgets, id: \.self) { budget in
                    Button { viewModel.currentBudgetId = budget.id }
                    label: { Text(budget.name).font(.callout) }
                        .padding(8)
                        .background(itemBackground(for: budget))
                        .foregroundStyle(viewModel.currentBudgetId == budget.id ? Color.white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .buttonStyle(.plain)
                        .onLongPressGesture {
                            editableBudget = budget
                            showModal.toggle()
                        }
                }
            }
            .onChange(of: viewModel.currentBudgetId) { _, new in
                if let currentBudget = viewModel.budgets.first(where: { $0.id == new }) {
                    editableBudget = currentBudget
                }
            }
        }
    }
}
