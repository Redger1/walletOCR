//
//  Transactions.swift
//  DesignSystem
//
//  Created by Артем on 20.10.2025.
//
import SwiftUI
import CoreTypes

public struct TransactionListItem: View {
    var transaction: TransactionItem
    var formattedMoney: String
    
    public init(transaction: TransactionItem, formattedMoney: String) {
        self.transaction = transaction
        self.formattedMoney = formattedMoney
    }
    
    public var body: some View {
        HStack {
            Image(systemName: transaction.categoryKind.iconName)
            VStack(alignment: .leading) {
                Text(transaction.categoryKind.title)
                if let merchant = transaction.merchant {
                    Text(merchant)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(formattedMoney)
                Text(transaction.date, format: .dateTime.day().month().year())
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}
