//
//  ModalCreateView.swift
//  WalletApp
//
//  Created by Артем on 07.10.2025.
//
import SwiftUI
import CoreTypes

struct ModalCreateView: View {
    let viewModel: TransactionViewModel
    @Binding var showModal: Bool
    @Binding var editableTx: TransactionItem?
    
    init(viewModel: TransactionViewModel, showModal: Binding<Bool>, editableTx: Binding<TransactionItem?>) {
        self.viewModel = viewModel
        self._showModal = showModal
        self._editableTx = editableTx
    }
    
    @State private var merchantName: String = ""
    @State private var totalPrice: String = ""
    @State private var category: CategoryKind = .other
    @State private var status: TransactionStatus = .pending
    @State private var paymentMethod: PaymentMethod = .card
    @State private var date: Date = Date()
    @State private var note: String = ""
    
    private func onAddTransaction() async {
        guard let total = Decimal(string: totalPrice), total > 0 else { return }
        
        if let editableTx {
            let itemToEdit = TransactionItem(
                id: editableTx.id,
                date: date,
                categoryKind: category,
                receiptID: editableTx.receiptID,
                merchant: merchantName,
                total: Money(value: total, currency: .rub),
                paymentMethod: paymentMethod,
                status: status,
                note: note.isEmpty ? nil : note
            )
            await viewModel.updateTransaction(itemToEdit)
        } else {
            let itemToCreate = TransactionItem(
                date: date,
                categoryKind: category,
                merchant: merchantName.isEmpty ? nil : merchantName,
                total: Money(value: total, currency: .rub),
                paymentMethod: paymentMethod,
                status: status,
                note: note.isEmpty ? nil : note
            )
            await viewModel.addTransaction(itemToCreate)
        }
        showModal = false
    }
    
    private func fillEditableIfNeeded() {
        guard let editableTx else { return }
        merchantName = editableTx.merchant ?? ""
        totalPrice = editableTx.total.value.description
        category = editableTx.categoryKind
        status = editableTx.status ?? .pending
        paymentMethod = editableTx.paymentMethod ?? .card
        date = editableTx.date
        note = editableTx.note ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextInputField("Название магазина", value: $merchantName)
            TextInputField("Сумма", value: $totalPrice)
                .keyboardType(.decimalPad)
            
            Picker("Категория", selection: $category) {
                ForEach(CategoryKind.allCases, id: \.self) { category in
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: category.iconName)
                        Text(category.title)
                        Spacer()
                    }
                }
            }
            
            Picker("Статус", selection: $status) {
                ForEach(TransactionStatus.allCases, id: \.self) { status in
                    Text(status.title)
                }
            }
            
            Picker("Способ оплаты", selection: $paymentMethod) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Text(method.title)
                }
            }
            
            DatePicker("Дата", selection: $date)
                .datePickerStyle(.compact)
            
            TextInputField("Заметки", value: $note)
                .lineLimit(5...10)
            
            Button(editableTx != nil ? "Изменить" : "Добавить") {
                Task { @MainActor in
                    await onAddTransaction()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonSizing(.flexible)
            .disabled(totalPrice.isEmpty)
        }
        .padding()
        .onAppear { fillEditableIfNeeded() }
    }
}
