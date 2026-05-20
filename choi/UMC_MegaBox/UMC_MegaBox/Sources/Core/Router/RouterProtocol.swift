//
//  RouterProtocol.swift
//  UMC_MegaBox
//

import Foundation

/// 테스트 시 MockRouter를 주입할 수 있도록 프로토콜 기반 추상화
protocol RouterProtocol: AnyObject, Observable {
    associatedtype Destination: Hashable
    func push(_ route: Destination)
    func pop()
    func reset()
}
