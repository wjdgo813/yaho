//
//  Mountain.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/19.
//

import Foundation
import RxSwift
import RxCocoa

extension Model {
    struct Mountain: Codable, ParsingProtocol, Equatable {
        let id: Int
        let name: String
        let height: Float
        let latitude: Double
        let longitude: Double
        let level: Level
        
        enum CodingKeys: String,CodingKey {
            case id, name, height, latitude, longitude, level
        }
        
        enum Level: String, Codable {
            case platinum = "최상"
            case top      = "상"
            case middle   = "중"
            case bottom   = "하"
        }
    }

}

extension Array where Element == Model.Mountain {
    static func asJSON(with data: Any) -> [Model.Mountain]? {
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let result = try decoder.decode([Model.Mountain].self, from: data)
            return result
        } catch {
            return nil
        }
    }
}

protocol MountainsStream: AnyObject {
    var mountains: Observable<[Model.Mountain]?> { get }
}

protocol MutableMountainsStream: MountainsStream {
    func updateMountains(with mountains: [Model.Mountain])
}

class MountainsStreamImpl: MutableMountainsStream {
    var mountains: Observable<[Model.Mountain]?> {
        return self.variable.asObservable()
            .distinctUntilChanged()
    }
    
    func updateMountains(with mountains: [Model.Mountain]) {
        self.variable.onNext(mountains)
    }
    
    private let variable = BehaviorSubject<[Model.Mountain]?>(value: nil)
}
