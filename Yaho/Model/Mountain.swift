//
//  Mountain.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/19.
//

import Foundation

struct Mountain: Codable, ParsingProtocol {
    let id: Int
    let name: String
    let height: Float
    let latitude: Double
    let longitude: Double
    let level: String
    
    enum CodingKeys: String,CodingKey {
        case id, name, height, latitude, longitude, level
    }
}


extension Array where Element == Mountain {
    static func asJSON(with data: Any) -> [Mountain]? {
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let result = try decoder.decode([Mountain].self, from: data)
            return result
        } catch {
            return nil
        }
    }
}
