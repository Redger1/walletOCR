//
//  MoneyFormatter.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI
import Foundation
import CoreTypes

enum MoneyFormatter {
    static func string(_ money: Money) -> String {
        let number = money.value.formatted()
        return "\(number)\(money.currency.symbol)"
    }
}
