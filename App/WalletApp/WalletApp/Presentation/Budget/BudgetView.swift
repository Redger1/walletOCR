//
//  BudgetView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import CoreTypes

struct BudgetView: View {
    @State private var viewModel: BudgetViewModel
    @State private var selectedScope: Set<CategoryKind> = [.food, .health]
    
    init(viewModel: BudgetViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Picker("Бюджет", selection: $viewModel.currentBudgetId) {
                ForEach(viewModel.budgets, id: \.id) { budget in
                    Text(viewModel.budgetTitle(budget))
                        .tag(Optional(budget.id))
                }
            }
            
            List {
                Section("Текущий бюджет") {
                    if let snapshot = viewModel.snapshot {
                        Text(verbatim: "Лимит: \(MoneyFormatter.string(snapshot.planned))")
                        Text(verbatim: "Потрачено: \(MoneyFormatter.string(snapshot.spent))")
                        Text(verbatim: "Осталось: \(MoneyFormatter.string(snapshot.remaining))")
                        ProgressView(value: Double(truncating: snapshot.progress as NSNumber), total: 1)
                    } else {
                        Text("Бюджет не выбран")
                    }
                }
                
                Section("Транзакции") {
                    if viewModel.filteredTransactions.isEmpty {
                        Text("Нет транзакций для выбранного бюджета")
                    } else {
                        ForEach(viewModel.filteredTransactions, id: \.id) { transaction in
                            HStack {
                                Text(transaction.categoryKind.rawValue)
                                Spacer()
                                Image(systemName: transaction.categoryKind.iconName)
                            }
                        }
                    }
                }
                
                Button("Добавить моковую транзакцию") {
                    Task {
                        await viewModel.addTransaction(Fixtures.makeRandomTransaction())
                    }
                }
                Button("Удалить моковую транзакцию") {
                    Task {
                        guard let lastTransaction = viewModel.transactions.last else { return }
                        await viewModel.deleteTransaction(lastTransaction)
                    }
                }
            }
        }
        .navigationTitle("Бюджет")
        .task {
            await viewModel.load()
        }
    }
}
