//
//  ViewController.swift
//  FuelCostForecast
//
//  Created by 김지수 on 2023/02/14.
//

import UIKit

class ViewController: UIViewController {
    
    let network = NetworkManager()
    let dateManager = DateManager()
    var currencyDatas: [CurrencyData] = [] {
        didSet {
            if currencyDatas.count == 7 {
                dump(currencyDatas)
            }
        }
    }
    
    var brentFuelDatas: [BrentFuelPrice] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dates = DateManager().getOffsetDatesString()
        let urls = network.getCurrencyURL(dates: dates)
        
        urls.forEach {
            network.getCurrencyDatas(url: $0) { [weak self] result in
                self?.currencyDatas.append(result)
            }
        }
        
        network.getFuelAvgRecentPrice {
            dump($0)
        }
        
        network.getBrentFuelMonthPrice { [weak self] price in
//            dump(price)
            self?.brentFuelDatas = price
            self?.dataProcessing()
        }
    }
    
    func dataProcessing() {
        
        let offsetDates = dateManager.getOffsetDates()
        
        // 1. 브렌트유 데이터를 기준 날짜에 맞게 필터
        let filtered = brentFuelDatas.filter { brent in
            
            var isMatch = false
            
            offsetDates.forEach { [weak self] date in
                if self?.isSameDay(date1: brent.createdAt, date2: date) == true {
                    isMatch = true
                }
            }
            return isMatch
        }
        let dbModel = makeHistoryDB(price: filtered, currency: self.currencyDatas)
        predict(data: dbModel)
    }
    
    func makeHistoryDB(price: [BrentFuelPrice], currency: [CurrencyData]) -> [DBModel] {
        var reverseCurrency = currency
        reverseCurrency.reverse()
        
        print("============DB==========")
        print("============CURRENCY==========")
        dump(reverseCurrency)
        print("============PRICE==========")
        dump(price)
        
        var DBDataModel: [DBModel] = []
        
        reverseCurrency.enumerated().forEach { (index: Int, currency: CurrencyData) in
            let model = DBModel(date: currency.date, price: price[index].price, currency: currency.krw)
            DBDataModel.append(model)
        }
        print("============MODEL==========")
        dump(DBDataModel)
        return DBDataModel
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func predict(data: [DBModel]) {
        var total: Double = 0.0
        data.forEach { model in
            total += model.purchasePrice
        }
        print("total: \(total / Double(data.count))")
    }
}
