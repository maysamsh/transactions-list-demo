//
//  TransactionRow.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionEntity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.fromAccount)
                    .lineLimit(1)
                
                Text(transaction.merchantName)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.caption)
                if let description = transaction.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            Spacer()
            Text(formattedAmount)
                .fontWeight(.medium)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.horizontal)
    }
    
    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = transaction.amount.currency.rawValue
        
        return formatter.string(from: NSNumber(value: transaction.amount.value)) ?? ""
    }
}

#Preview {
    TransactionRow(transaction: TransactionEntity(
        id: "sTZmzAb7AsYLknHOZijbIAQY0aw-S-I5UgidESsFJ24=",
        transactionType: .debit,
        merchantName: "Payment-thank You Scotiabank Transit 40592 Markham On",
        description: "Transit",
        amount: TransactionEntity.Amount(
            value: 5,
            currency: .cad
        ),
        postedDate: Date(),
        fromAccount: "Passport Visa Infinite",
        fromCardNumber: "4537350001688004"
    ))
}
