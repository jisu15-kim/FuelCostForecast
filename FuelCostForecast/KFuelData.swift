//
//  FuelData.swift
//  FuelCostForecast
//
//  Created by 김지수 on 2023/02/15.
//

import Foundation

// MARK: - FuelResult
struct KFuelData: Codable {
    let result: KFuelResult
    
    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

// MARK: - Result
struct KFuelResult: Codable {
    let oil: [KFuelOil]
    
    enum CodingKeys: String, CodingKey {
        case oil = "OIL"
    }
}

// MARK: - Oil
struct KFuelOil: Codable {
    let date: Date
    let prodcd: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "DATE"
        case prodcd = "PRODCD"
        case price = "PRICE"
    }
}

