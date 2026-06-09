//
//  BudgetView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import CoreTypes
import DesignSystem

struct BudgetView: View {
    @State private var viewModel: BudgetViewModel
    @State private var showModal: Bool = false
    @State private var editableBudget: Budget? = nil
    
    init(viewModel: BudgetViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                BudgetSelector(viewModel: viewModel)
                
                if let currentBudget = viewModel.budgets.first(where: { $0.id == viewModel.currentBudgetId }) {
                    HStack {
                        Button {
                            editableBudget = currentBudget
                            showModal.toggle()
                        } label: { Text("Edit") }
                        
                        Button { Task { await viewModel.deleteBudget(currentBudget) } }
                        label: { Text("Delete") }
                    }
                }
                
                if let snapshot = viewModel.snapshot {
                    VStack(alignment: .leading) {
                        Text("Left")
                            .font(.system(size: 22, weight: .medium))
                        Text(MoneyFormatter.string(snapshot.remaining))
                            .font(.system(size: 32, weight: .bold))
                        Text("Limit \(MoneyFormatter.string(snapshot.planned)) потрачено \(MoneyFormatter.string(snapshot.spent))")
                            .font(.system(size: 18, weight: .medium))
                            .opacity(0.5)
                        
                        ProgressView(value: Double(truncating: snapshot.progress as NSNumber), total: 1)
                            .tint(.indigo)
                    }
                    .capsuleBackground()
                }
                
                if let snapshot = viewModel.snapshot {
                    CircularBudgetProgress(snapshot: snapshot)
                }
                
                Text("Transactions")
                    .font(.system(size: 22, weight: .medium))
                if viewModel.filteredTransactions.isEmpty {
                    Text("No transactions for selected budget")
                } else {
                    ForEach(viewModel.filteredTransactions, id: \.id) { transaction in
                        TransactionListItem(transaction: transaction, formattedMoney: MoneyFormatter.string(transaction.total))
                    }
                }
            }
        }
        .contentMargins(20)
        .navigationTitle("Budget")
        .task { await viewModel.load() }
        .sheet(isPresented: $showModal) {
            CreateBudgetView(viewModel: viewModel, showModal: $showModal, editableBudget: $editableBudget)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editableBudget = nil
                    showModal.toggle()
                }
                label: { Image(systemName: "plus") }
            }
        }
    }
}
