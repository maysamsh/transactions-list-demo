//
//  TransactionList.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import SwiftUI

struct TransactionList: View {
    @StateObject private var viewMode: TransactionListViewModel = .init()
    @State private var selectedTransaction: TransactionEntity?

    var body: some View {
        VStack {
            switch viewMode.viewState {
            case .loading:
                loadingStateView()
            case .ready(let transactions):
                readyState(transactions: transactions)
            case .error(let error):
                errorStateView(message: error.localizedDescription)
            case .empty:
                emptyStateView()
            }
        }
        .task {
            await viewMode.fetchTransactions()
        }
        .padding()
        .fullScreenCover(item: $selectedTransaction) { transaction in
            TransactionDetailView(transaction: transaction)
        }
        .navigationTitle("Transactions List")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func readyState(transactions: [TransactionEntity]) -> some View {
        ScrollView {
            ForEach(transactions) { transaction in
                TransactionRow(transaction: transaction)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTransaction = transaction
                    }
                if transaction != transactions.last {
                    Divider()
                }
            }
        }
    }

    private func loadingStateView() -> some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func emptyStateView() -> some View {
        VStack{
            Text("No transactions")
                .font(.headline)
            
            Text("Transactions will appear here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func errorStateView(message: String) -> some View {
        VStack {
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TransactionList()
}
