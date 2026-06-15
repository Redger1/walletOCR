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
    @State private var editableTx: TransactionItem? = nil
    @State private var showShareSheet: Bool = false
    
    init(viewModel: TransactionViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    private func handleEdit(_ transaction: TransactionItem) {
        editableTx = transaction
        showModal = true
    }
    
    private func handleCreate() {
        editableTx = nil
        showModal = true
    }
    
    private func exportCSV() {
        viewModel.exportCSV()
        if viewModel.exportURL != nil {
            showShareSheet = true
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Text("\(viewModel.filteredTotalSpentMoney.description)")
                        .font(.largeTitle.bold())
                    Text("Total spent")
                        .font(.callout).opacity(0.7)
                }
                Spacer()
            }
            .capsuleBackground()
            
            Section {
                Picker("Period", selection: $viewModel.selectedPeriod) {
                    ForEach(TransactionPeriodFilter.allCases) { item in
                        Text(item.title)
                    }
                }.pickerStyle(.segmented)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button { viewModel.selectedCategory = .none }
                    label: { Text("All").font(.callout) }
                        .padding(8)
                        .background(viewModel.selectedCategory == .none ? Color.indigo : Color(UIColor.secondarySystemBackground))
                        .foregroundStyle(viewModel.selectedCategory == .none ? Color.white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .buttonStyle(.plain)
                    
                    ForEach(CategoryKind.allCases, id: \.self) { category in
                        Button { viewModel.selectedCategory = category }
                        label: { Text(category.title).font(.callout) }
                            .padding(8)
                            .background(viewModel.selectedCategory == category ? Color.indigo : Color(UIColor.secondarySystemBackground))
                            .foregroundStyle(viewModel.selectedCategory == category ? Color.white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .buttonStyle(.plain)
                    }
                }
            }
            
            if viewModel.filteredTransactions.isEmpty {
                Text("No transactions")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold))
            } else {
                List {
                    Section {
                        ForEach(viewModel.filteredTransactions, id: \.id) { item in
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
                }
                .refreshable { await viewModel.load() }
                .searchable(text: $viewModel.searchText, prompt: "Search transactions")
                .listStyle(.plain)
            }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $showModal, onDismiss: { editableTx = nil }) {
            ModalCreateView(viewModel: viewModel, showModal: $showModal, editableTx: $editableTx)
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = viewModel.exportURL {
                ShareSheet(items: [url])
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { handleCreate() }
                label: { Image(systemName: "plus") }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { exportCSV() }
                label: { Image(systemName: "square.and.arrow.up" ) }
            }
        }
        .padding()
    }
}
