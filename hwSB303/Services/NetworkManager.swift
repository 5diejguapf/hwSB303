//
//  NetworkManager.swift
//  hwSB303
//
//  Created by serg on 16.07.2023.
//

import Foundation

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
