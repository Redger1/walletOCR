//
//  TransactionView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import CoreTypes
import DesignSystem

struct TransactionView: View {
    @State private var viewModel: TransactionViewModel
    @State private var showModal: Bool = false
    @State private var selectedCategory: CategoryKind? = .none
    @State private var editableTx: TransactionItem? = nil
    
    init(viewModel: TransactionViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var sortedByCategories: [TransactionItem] {
        if selectedCategory == .none {
            return viewModel.sortedTransactions
        } else {
            return viewModel.sortedTransactions.filter { $0.categoryKind == selectedCategory }
        }
    }
    
    private func handleEdit(_ transaction: TransactionItem) {
        editableTx = transaction
        showModal.toggle()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Text("\(viewModel.totalSpentMoney.description)")
                        .font(.largeTitle.bold())
                    Text("Всего потрачено")
                        .font(.callout).opacity(0.7)
                }
                Spacer()
            }
//            .padding(.vertical, 20)
            .capsuleBackground()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button { selectedCategory = .none }
                    label: { Text("Все").font(.callout) }
                        .padding(8)
                        .background(selectedCategory == .none ? Color.indigo : Color(UIColor.secondarySystemBackground))
                        .foregroundStyle(selectedCategory == .none ? Color.white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .buttonStyle(.plain)
                    
                    ForEach(CategoryKind.allCases, id: \.self) { category in
                        Button { selectedCategory = category }
                        label: { Text(category.title).font(.callout) }
                            .padding(8)
                            .background(selectedCategory == category ? Color.indigo : Color(UIColor.secondarySystemBackground))
                            .foregroundStyle(selectedCategory == category ? Color.white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .buttonStyle(.plain)
                    }
                }
            }
            
            if sortedByCategories.count == 0 {
                Text("Нет транзакций")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold))
            }
            List {
                ForEach(sortedByCategories, id: \.id) { item in
                    TransactionListItem(transaction: item, formattedMoney: MoneyFormatter.string(item.total))
                        .swipeActions {
                            Button { handleEdit(item) }
                            label: { Image(systemName: "pencil") }
                                .tint(.green)
                        }
                        .swipeActions {
                            Button { Task { await viewModel.deleteTransaction(item) } }
                            label: { Image(systemName: "trash") }
                                .tint(.red)
                        }
                }
            }
            .refreshable { await viewModel.load() }
            .listStyle(.plain)
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $showModal) {
            ModalCreateView(viewModel: viewModel, showModal: $showModal, editableTx: $editableTx)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showModal.toggle() }
                label: { Image(systemName: "plus") }
            }
        }
        .padding()
    }
}
