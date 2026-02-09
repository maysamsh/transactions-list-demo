//
//  TransactionListTests.swift
//  TransactionListTests
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import Testing
import Foundation
@testable import TransactionList

struct TransactionListTests {
    @Test func testSuccess() async throws {
        let mock = MockAPIService()
        mock.behaviour = .success
        let transactions = try await mock.fetchTransactions()
        #expect(!transactions.isEmpty)
    }

    @Test func testEmpty() async throws {
        let mock = MockAPIService()
        mock.behaviour = .empty
        let transactions = try await mock.fetchTransactions()
        #expect(transactions.isEmpty)
    }

    @Test func tesError() async {
        let mock = MockAPIService()
        mock.behaviour = .error(URLError(.notConnectedToInternet))
        do {
            let response = try await mock.fetchTransactions()
            #expect(Bool(false), "Expected throw, \(response.count) records returned!")
        } catch {
            #expect(error is URLError)
        }
    }

}
