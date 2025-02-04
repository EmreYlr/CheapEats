//
//  ProductError.swift
//  CheapEats
//
//  Created by Emre on 3.02.2025.
//

enum CustomError: Error {
    case invalidDocument
    case decodingError
    case noData
    case networkError(Error)
}
