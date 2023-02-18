//
//  BrentFuelData.swift
//  FuelCostForecast
//
//  Created by 김지수 on 2023/02/18.
//

import Foundation

import Foundation

// MARK: - BrentFuelResult
struct BrentFuelData: Codable {
    let status: String
    let data: BrentFuelResult
}

// MARK: - DataClass
struct BrentFuelResult: Codable {
    let prices: [BrentFuelPrice]
}

// MARK: - Price
struct BrentFuelPrice: Codable {
    let price: Double
    let formatted: String
    let currency: String
    let code: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case price
        case formatted
        case currency
        case code
        case createdAt = "created_at"
    }
}
