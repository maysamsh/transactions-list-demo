//
//  TransactionListViewModel.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import Foundation
import Combine

final class TransactionListViewModel: ObservableObject {
    enum TransactionListViewState {
        case loading
        case ready([TransactionEntity])
        case error(Error)
        case empty
    }
    
    private let apiService: APIServiceType
    
    @Published var viewState: TransactionListViewState = .loading
    
    init(apiService: APIServiceType = APIService.shared) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchTransactions() async {
        do {
            let transactions = try await apiService.fetchTransactions()
            if transactions.isEmpty {
                self.viewState = .empty
            } else {
                self.viewState = .ready(transactions.sorted { $0.postedDate > $1.postedDate })
            }
        } catch {
            self.viewState = .error(error)
        }
    }
    
    private func formattedAmount(currencyCode: String, amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
}
