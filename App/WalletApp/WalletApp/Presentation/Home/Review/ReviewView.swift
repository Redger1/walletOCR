//
//  ReviewView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import VisionOCRKit
import CoreTypes

struct ReviewView: View {
    @State var reviewVM: ReviewViewModel
    var goBack: () -> Void
    var returnToHome: () -> Void
    
    init(reviewVM: ReviewViewModel, returnToHome: @escaping () -> Void, goBack: @escaping () -> Void) {
        self.goBack = goBack
        self.returnToHome = returnToHome
        self._reviewVM = State(wrappedValue: reviewVM)
    }
    
    private var isCreateDisabled: Bool {
        reviewVM.draft.total == nil ||
        (reviewVM.draft.total?.value ?? 0) <= 0
    }
    
    var body: some View {
        Form {
            DatePicker(
                "Дата",
                selection: Binding(
                    get: { reviewVM.draft.date ?? Date() },
                    set: { reviewVM.draft.date = $0 }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            
            TextInputField(
                "Название магазина",
                value: Binding(
                    get: { reviewVM.draft.merchant ?? "" },
                    set: { new in
                        let trimmed = new.trimmingCharacters(in: .whitespacesAndNewlines)
                        reviewVM.draft.merchant = trimmed.isEmpty ? nil : trimmed
                    }
                )
            )
            
            TextInputField(
                "Сумма",
                value: Binding(
                    get: { reviewVM.draft.total.map { $0.value.description } ?? "" },
                    set: { new in
                        let dec = Parser.parseDecimal(new)
                        reviewVM.draft.total = dec.map { Money(value: $0, currency: .rub) }
                    }
                )
            )
            
            VStack(alignment: .leading, spacing: 10) {
                if let category = reviewVM.suggestedCategorySnapshot,
                   let confidence = reviewVM.suggestedConfidenceSnapshot {
                    Text("Предложенная категория: \(category.title) \(Int(confidence*100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Picker("Категория", selection: $reviewVM.draft.suggestedCategory) {
                    Text("Не выбрано").tag(Optional<CategoryKind>.none)
                    ForEach(CategoryKind.allCases, id: \.self) { category in
                        Text(category.title)
                    }
                }
            }
            
            Picker(
                "Способ оплаты",
                selection: Binding(
                    get: { reviewVM.draft.paymentMethod },
                    set: { reviewVM.draft.paymentMethod = $0 }
                )
            ) {
                Text("Не указано").tag(Optional<PaymentMethod>.none)
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Text(method.title)
                }
            }
            
            TextInputField(
                "Заметки",
                value: Binding(
                    get: { reviewVM.draft.note ?? "" },
                    set: { new in
                        let trimmed = new.trimmingCharacters(in: .whitespacesAndNewlines)
                        reviewVM.draft.note = trimmed
                    }
                )
            )
            .lineLimit(5...10)

            Button("Создать") { createTransaction() }
                .disabled(isCreateDisabled)
            
            Button("Назад") { goBack() }
        }
        .formStyle(.grouped)
    }
    
    private func createTransaction() {
        guard let total = reviewVM.draft.total, let date = reviewVM.draft.date else {
            print("Нет total или date")
            return
        }
        
        let transactionItem = TransactionItem(
            date: date,
            categoryKind: reviewVM.draft.suggestedCategory,
            merchant: reviewVM.draft.merchant,
            total: total,
            paymentMethod: reviewVM.draft.paymentMethod,
            note: reviewVM.draft.note
        )
        
        Task {
            await reviewVM.transactionRepo.add(transactionItem)
            returnToHome()
        }
    }
}
