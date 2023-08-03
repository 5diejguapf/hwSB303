//
//  NetworkManager.swift
//  hwSB303
//
//  Created by serg on 16.07.2023.
//

import Foundation
import Alamofire

enum Links: String {
    case allFortsSecurities = "https://iss.moex.com/iss/engines/futures/markets/forts/securities.json"
}

enum NetManagerError: Error {
    case NoDataFound
    case Other
    case UrlParsing
    case Decoding
}

class NetworkManager {
    static let shared = NetworkManager()
    var responseDurations: [Double] = []
    
    private init() {}
    
    func fetchFortsAllSecAF(complation: @escaping (Result<AllFortsSecResponse, Error>) -> Void) {
        AF.request(Links.allFortsSecurities.rawValue)
            .validate()
            .responseJSON { responseData in
                switch responseData.result {
                case .success(let values):
                    guard let issData = values as? [String: Any] else { complation(.failure(NetManagerError.Decoding)); return }
                    
                    guard let securities = issData["securities"] as? [String: Any] else { complation(.failure(NetManagerError.Decoding)); return  }
                    guard let secColumns = securities["columns"] as? [String] else { complation(.failure(NetManagerError.Decoding)); return }
                    guard let secData = securities["data"] as? [[Any]] else { complation(.failure(NetManagerError.Decoding)); return }
                    
                    var securitiesInfo: [IssFortsSecurityInfo] = []
                    for security in secData {
                        do {
                            let secDict = Dictionary( uniqueKeysWithValues: zip(secColumns.map { $0.lowercased() }, security ))
                            let secInfo = try IssFortsSecurityInfo(from: secDict)
                            securitiesInfo.append(secInfo)
                        } catch {
                            print(error)
                        }
                    }
                    let fortsSecData = FortsSecurityData(data: securitiesInfo)
                    
                    guard let marketdata = issData["marketdata"] as? [String: Any] else { complation(.failure(NetManagerError.Decoding)); return }
                    guard let marketColumns = marketdata["columns"] as? [String] else { complation(.failure(NetManagerError.Decoding)); return }
                    guard let markData = marketdata["data"] as? [[Any]] else { complation(.failure(NetManagerError.Decoding)); return }

                    var marketInfos: [IssFortsMarketInfo] = []
                    for market in markData {
                        do {
                            let marketDict = Dictionary( uniqueKeysWithValues: zip(marketColumns.map { $0.lowercased() }, market ))
                            let marketInfo = try IssFortsMarketInfo(from: marketDict)
                            marketInfos.append(marketInfo)
                        } catch {
                            print(error)
                        }
                    }
                    
                    let fortsMarketData = FortsMarketData(data: marketInfos)
                    let result: AllFortsSecResponse = AllFortsSecResponse(securities: fortsSecData, marketdata: fortsMarketData)
                    complation(.success(result))
                case .failure(let error):
                    print(error)
                    complation(.failure(NetManagerError.Other))
                }
            }
        
    }
    
    func fetchFortsAllSecurities(complation: @escaping (Result<AllFortsSecResponse, Error>) -> Void) {
        guard let url = URL(string: Links.allFortsSecurities.rawValue) else {
            return complation(.failure(NetManagerError.UrlParsing))
        }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data else {
                return complation(.failure(NetManagerError.NoDataFound))
            }
            if let err = err {
                print(err.localizedDescription)
                return complation(.failure(NetManagerError.Other))
            }
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            do {
                let t0 = Date.now
                let response = try decoder.decode(AllFortsSecResponse.self, from: data)
                self.responseDurations.append(t0.distance(to: Date.now) * 1000)
                complation(.success(response))
            
            } catch {
                print("Error: \(error.localizedDescription)")
                complation(.failure(NetManagerError.Decoding))
            }
        }.resume()
    }
}
