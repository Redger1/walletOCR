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
                ForEach(viewModel.transactions, id: \.id) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(MoneyFormatter.string(item.total))
                            Spacer()
                            HStack(alignment: .center, spacing: 10) {
                                Text(item.categoryKind.rawValue)
                                Image(systemName: item.categoryKind.iconName)
                            }
                        }
                        
                        HStack {
                            Text(item.paymentMethod?.rawValue ?? "")
                            Spacer()
                            Text(item.date, style: .date)
                        }
                        
                        if let note = item.note {
                            Text(note).multilineTextAlignment(.leading)
                        }
                    }
                }
            }
            
            Button("Добавить новую транзакцию") { showModal.toggle() }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $showModal) {
            VStack {
            }
        }
    }
}
