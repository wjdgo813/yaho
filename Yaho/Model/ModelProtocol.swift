//
//  ModelProtocol.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/21.
//

import Foundation

protocol ParsingProtocol where Self: Decodable {
    static func asJSON(with data: Any) -> Self?
}

extension ParsingProtocol {
    static func asJSON(with data: Any) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let result = try decoder.decode(Self.self, from: data)
            return result
        } catch {
            return nil
        }
    }
}

struct Model {
    
}
