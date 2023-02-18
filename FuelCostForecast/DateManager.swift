//
//  DateManager.swift
//  FuelCostForecast
//
//  Created by 김지수 on 2023/02/14.
//

import Foundation

class DateManager {
    
    let formatter = DateFormatter()
    
    
    func getOffsetDatesString() -> [String] {
        formatter.dateFormat = "yyyy-MM-dd"
        var offsetDates: [String] = []
        
        // 14일 ~ 21일 전 날짜 구하기
        for date in 15...21 {
            if let result = Calendar.current.date(byAdding: .day, value: -date, to: Date()) {
                offsetDates.append(formatter.string(from: result))
            }
        }
        dump(offsetDates)
        return offsetDates
    }
    
    func getOffsetDates() -> [Date] {
        formatter.dateFormat = "yyyy-MM-dd"
        var offsetDates: [Date] = []
        
        // 14일 ~ 21일 전 날짜 구하기
        for date in 15...21 {
            if let result = Calendar.current.date(byAdding: .day, value: -date, to: Date()) {
                offsetDates.append(result)
            }
        }
        dump(offsetDates)
        return offsetDates
    }
}
