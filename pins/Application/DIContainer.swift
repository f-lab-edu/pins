//
//  DIContainer.swift
//  pins
//
//  Created by 주동석 on 11/18/23.
//

final class DIContainer {
    static let shared = DIContainer()
    
    private var dependencies = [String: Any]()

    private init() {}

    func register<T>(_ dependency: T, as type: T.Type = T.self) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("\(key)는 register되지 않았어요. resolve 부르기 전에 register 해주세요.")
        }
        return dependency
    }
}
