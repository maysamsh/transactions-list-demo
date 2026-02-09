//
//  TransactionListResponse.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import Foundation

struct TransactionListResponse: Codable {
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let key: String
    let transactionType: TransactionType
    let merchantName: String
    let description: String?
    let amount: Amount
    let postedDate: Date
    let fromAccount: String
    let fromCardNumber: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        key = try container.decode(String.self, forKey: .key)
        transactionType = try container.decode(TransactionType.self, forKey: .transactionType)
        merchantName = try container.decode(String.self, forKey: .merchantName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        amount = try container.decode(Amount.self, forKey: .amount)
        fromAccount = try container.decode(String.self, forKey: .fromAccount)
        fromCardNumber = try container.decode(String.self, forKey: .fromCardNumber)
        
        let dateString = try container.decode(String.self, forKey: .postedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .postedDate,
                in: container,
                debugDescription: "Date string does not match format yyyy-MM-dd"
            )
        }
        
        postedDate = date
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case transactionType = "transaction_type"
        case merchantName = "merchant_name"
        case description, amount
        case postedDate = "posted_date"
        case fromAccount = "from_account"
        case fromCardNumber = "from_card_number"
    }
    
    struct Amount: Codable {
        let value: Double
        let currency: Currency
    }

    enum Currency: String, Codable {
        case cad = "CAD"
        case usd = "USD"
    }

    enum TransactionType: String, Codable {
        case credit = "CREDIT"
        case debit = "DEBIT"
    }
}

struct TransactionEntity: Sendable, Identifiable, Equatable {
    static func == (lhs: TransactionEntity, rhs: TransactionEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let transactionType: TransactionType
    let merchantName: String
    let description: String?
    let amount: Amount
    let postedDate: Date
    let fromAccount: String
    let fromCardNumber: String
    
    struct Amount {
        let value: Double
        let currency: Currency
    }

    enum Currency: String {
        case cad = "CAD"
        case usd = "USD"
    }

    enum TransactionType: String {
        case credit = "CREDIT"
        case debit = "DEBIT"
    }
}
