//
//  APIService.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import Foundation

protocol APIServiceType {
    func fetchTransactions() async throws -> [TransactionEntity]
}

final class APIService: APIServiceType {
    static let shared = APIService()
    
    private init() {}
    
    func fetchTransactions() async throws -> [TransactionEntity] {
        try await Task.sleep(nanoseconds: 1_000_000)
        
        let transactions = try loadTransactionListResponse()
        
        return transactions.transactions.map { $0.toEntity() }
    }
    
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

extension Transaction {
    func toEntity() -> TransactionEntity {
        TransactionEntity(
            id: key,
            transactionType: TransactionEntity.TransactionType(rawValue: transactionType.rawValue) ?? .debit,
            merchantName: merchantName,
            description: description,
            amount: TransactionEntity.Amount(
                value: amount.value,
                currency: TransactionEntity.Currency(rawValue: amount.currency.rawValue) ?? .cad
            ),
            postedDate: postedDate,
            fromAccount: fromAccount,
            fromCardNumber: fromCardNumber
        )
    }
}
