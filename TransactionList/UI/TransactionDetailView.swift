//
//  TransactionDetailView.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import SwiftUI

struct TransactionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let transaction: TransactionEntity
    private let headerHeight: CGFloat = 120

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    Text("Transaction Details")
                    .font(.title2)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
            }
            .background(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: headerHeight)
            
            VStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: .zero) {
                    VStack(spacing: .zero) {
                        Image("success-icon")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .foregroundStyle(typeColor)
                            .frame(maxWidth: .infinity)

                        Text(transactionType)
                            .font(.subheadline)
                            .foregroundStyle(typeColor)
                            .frame(maxWidth: .infinity)
                            .padding(.top)

                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(fromDisplayText)
                                .font(.body)
                            if let description = transaction.description {
                                Text("\(description)")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 25)

                        Divider()
                            .padding(.vertical)

                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(formattedAmount)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(alignment: .top) {
                            Image("buddy-tip-icon")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .padding()
                            ExpandableTextView(
                                texts: [
                                    "Transactions are processed Monday to Friday (excluding holidays).",
                                    "\nTransactions made before 8:30 pm ET Monday to Friday (excluding holidays) will show up in your account the same day."
                                ]
                            )
                            .padding()
                        }
                        .border(Color(.separator), width: 0.5)
                        .padding(.horizontal)
                        .padding(.top, 50)
                    }
                    .padding()

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding()
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(.separator), lineWidth: 1)
                )
                .padding(.horizontal)
            }
            
            .safeAreaPadding(.vertical)
            .padding(.top, headerHeight)

        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.systemGroupedBackground)
        )
    }

    
    private var typeColor: Color {
        switch transaction.transactionType {
            case .credit: .green
            case .debit: .red
        }
    }

    private var transactionType: String {
        switch transaction.transactionType {
            case .credit: "Credit transaction"
            case .debit: "Debit transaction"
        }
    }

    private var fromDisplayText: String {
        let lastFour = String(transaction.fromCardNumber.suffix(4))
        return "\(transaction.fromAccount) (\(lastFour))"
    }

    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = transaction.amount.currency.rawValue
        return formatter.string(from: NSNumber(value: transaction.amount.value)) ?? ""
    }
}

#Preview {
    TransactionDetailView(transaction: TransactionEntity(
        id: "sTZmzAb7AsYLknHOZijbIAQY0aw-S-I5UgidESsFJ24=",
        transactionType: .credit,
        merchantName: "Payment",
        description: nil,
        amount: TransactionEntity.Amount(value: 200.20, currency: .usd),
        postedDate: Date(),
        fromAccount: "Momentum Regular Visa",
        fromCardNumber: "4537350001688012"
    ))
}
