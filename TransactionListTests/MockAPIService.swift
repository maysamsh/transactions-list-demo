//
//  MockAPIService.swift
//  TransactionListTests
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import Foundation
@testable import TransactionList

final class MockAPIService: APIServiceType {
    enum MockBehavior {
        case success
        case empty
        case error(Error)
    }
    
    var behaviour: MockBehavior = .success

    func fetchTransactions() async throws -> [TransactionEntity] {
        switch behaviour {
        case .success:
            let response = try loadTransactionListResponse()
            return response.transactions.map { $0.toEntity() }
        case .empty:
            return []
        case .error(let error):
            throw error
        }
    }

    @MainActor
    private func loadTransactionListResponse() throws -> TransactionListResponse {
        guard let url = Bundle.main.url(forResource: "transaction-list", withExtension: "json") else {
            throw URLError(.badURL)
        }
        
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(TransactionListResponse.self, from: data)
        
        return response
    }
}
