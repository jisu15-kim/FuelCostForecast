//
//  NetworkManager.swift
//  FuelCostForecast
//
//  Created by 김지수 on 2023/02/14.
//

import Alamofire
import UIKit

class NetworkManager {
    
    private func getNormalDateDecoder(_ type: String) -> JSONDecoder {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = type
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
    
    func getCurrencyURL(dates: [String]) -> [URL] {

        var urlArray: [URL] = []
        dates.forEach {
            urlArray.append(URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/\($0)/currencies/usd/krw.json")!)
        }
        return urlArray
    }
    
    func getCurrencyDatas(url: URL, completion: @escaping (CurrencyData) -> Void) {
        
        let decoder = getNormalDateDecoder("yyyy-MM-dd")
        
        AF.request(url)
            .responseDecodable(of: CurrencyData.self, decoder: decoder, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    print("====성공===")
                    completion(response)
                case .failure(let error):
                    print("====실패===")
                    print(error)
                }
            })
    }
    
    func getFuelAvgRecentPrice(completion: @escaping ([KFuelOil]) -> Void) {
        
        let decoder = getNormalDateDecoder("yyyyMMdd")
        
        let url = URL(string: "http://www.opinet.co.kr/api/avgRecentPrice.do?out=json&code=\(Secret.opinetKey)&prodcd=B027")!
        print(url)
        
        AF.request(url)
            .responseDecodable(of: KFuelData.self, decoder: decoder, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    print("====성공===")
                    completion(response.result.oil)
                case .failure(let error):
                    print("====실패===")
                    print(error)
                }
            })
    }
    
    func getBrentFuelMonthPrice(completion: @escaping ([BrentFuelPrice]) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let url = URL(string: "https://api.oilpriceapi.com/v1/prices/past_month/?by_type=daily_average_price")!
        let key = HTTPHeader(name: "Authorization", value: Secret.fuelApiKey)
        let type = HTTPHeader(name: "Content-Type", value: "application/json")
        let headers = HTTPHeaders([key, type])
        
        print(url)
        
        AF.request(url, headers: headers)
            .responseDecodable(of: BrentFuelData.self, decoder: decoder, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    print("====성공===")
                    completion(response.data.prices)
                case .failure(let error):
                    print("====실패===")
                    print(error)
                }
            })
    }
}
