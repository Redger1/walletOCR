//
//  TransactionView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import CoreTypes

struct TransactionView: View {
    @State private var viewModel: TransactionViewModel
    @State private var showModal: Bool = false
    
    init(viewModel: TransactionViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.sortedTransactions, id: \.id) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(MoneyFormatter.string(item.total))
                            Spacer()
                            HStack(alignment: .center, spacing: 10) {
                                Text(item.categoryKind.title)
                                Image(systemName: item.categoryKind.iconName)
                            }
                        }
                        
                        HStack {
                            Text(item.paymentMethod?.title ?? "")
                            Spacer()
                            Text(item.date, format: .dateTime.day().month().year())
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        
                        if let note = item.note {
                            Text(note).multilineTextAlignment(.leading)
                        }
                    }
                }
                .onDelete { indexSet in
                    Task {
                        for idx in indexSet {
                            await viewModel.deleteTransaction(viewModel.sortedTransactions[idx])
                        }
                    }
                }
            }
            .refreshable { await viewModel.load() }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $showModal) {
            ModalCreateView(viewModel: viewModel, showModal: $showModal)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showModal.toggle() }
                label: { Image(systemName: "plus") }
            }
        }
    }
}
