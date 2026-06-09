//
//  CreateBudgetView.swift
//  WalletApp
//
//  Created by Артем on 20.10.2025.
//
import Foundation
import SwiftUI
import CoreTypes

struct CreateBudgetView: View {
    var viewModel: BudgetViewModel
    @Binding var showModal: Bool
    @Binding var editableBudget: Budget?
    @State private var name: String = ""
    @State private var rollOverRuleSelection: RolloverRule = .carryOver
    @State private var selectedCategories: Set<CategoryKind> = []
    @State private var moneyAmount: String = ""
    @State private var startDate: Date = Date.now
    
    let test = Budget(name: "", categoryScope: [.entertainment], amount: Money(value: 0, currency: .rub), startDate: Date.now, rolloverRule: .carryOver)
    
    func createBudget() async {
        if let editableBudget {
            let budgetToEdit = Budget(
                id: editableBudget.id,
                name: name,
                categoryScope: selectedCategories,
                amount: Money(value: Decimal(string: moneyAmount) ?? 0, currency: .rub),
                startDate: startDate,
                rolloverRule: rollOverRuleSelection
            )
            await viewModel.updateBudget(budgetToEdit)
        } else {
            let budget = Budget(
                name: name,
                categoryScope: selectedCategories,
                amount: Money(value: Decimal(string: moneyAmount) ?? 0, currency: .rub),
                startDate: startDate,
                rolloverRule: rollOverRuleSelection
            )
            await viewModel.addBudget(budget)
        }
        showModal = false
    }
    
    private func fillEditableIfNeeded() {
        guard let editableBudget else { return }
        name = editableBudget.name
        rollOverRuleSelection = editableBudget.rolloverRule
        selectedCategories = Set(editableBudget.categoryScope)
        moneyAmount = String(describing: editableBudget.amount.value)
        startDate = editableBudget.startDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextInputField("Title", value: $name)
            TextInputField("Budget (rub.)", value: $moneyAmount)
                .keyboardType(.numberPad)
            
            DatePicker("Start date", selection: $startDate)
                .datePickerStyle(.compact)
            
            List {
                ForEach(CategoryKind.allCases, id: \.self) { categoryItem in
                    Button {
                        if selectedCategories.contains(categoryItem) {
                            selectedCategories.remove(categoryItem)
                        } else {
                            selectedCategories.insert(categoryItem)
                        }
                    } label: {
                        HStack {
                            Text(categoryItem.title)
                            Spacer()
                            if selectedCategories.contains(categoryItem) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }.listStyle(.plain)
            
            Picker("Rollover rule", selection: $rollOverRuleSelection) {
                ForEach(RolloverRule.allCases, id: \.self) { item in
                    Text(item.title).tag(item)
                }
            }
            
            Button(editableBudget == nil ? "Add budget" : "Change budget") {
                Task { await createBudget() }
            }
        }
        .padding()
        .onAppear { fillEditableIfNeeded() }
    }
}
