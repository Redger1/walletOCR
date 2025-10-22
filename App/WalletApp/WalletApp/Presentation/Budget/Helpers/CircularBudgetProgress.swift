//
//  CircularBudgetProgress.swift
//  WalletApp
//
//  Created by Артем on 20.10.2025.
//
import SwiftUI
import CoreTypes

struct CircularBudgetProgress: View {
    var snapshot: BudgetSnapshot
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(Color(UIColor.secondarySystemBackground))
                
                Circle()
                    .trim(
                        from: 0,
                        to: min(CGFloat(NSDecimalNumber(decimal: snapshot.progress).doubleValue), 1)
                    )
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(.indigo)
                    .rotationEffect(.degrees(270))
                    .animation(.linear, value: snapshot.progress)
                
                Text("\(Int(NSDecimalNumber(decimal: snapshot.progress).doubleValue * 100))%")
                    .font(.system(size: 28, weight: .semibold))
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Запланировано:").opacity(0.6)
                    Spacer()
                    Text(MoneyFormatter.string(snapshot.planned))
                }
                HStack {
                    Text("Потрачено:").opacity(0.6)
                    Spacer()
                    Text(MoneyFormatter.string(snapshot.spent))
                }
                HStack {
                    Text("Остаток:").opacity(0.6)
                    Spacer()
                    Text(MoneyFormatter.string(snapshot.remaining))
                }
//                Text("В день: \(MoneyFormatter.string(snapshot.planned))")
            }
        }
        .capsuleBackground()
    }
}
