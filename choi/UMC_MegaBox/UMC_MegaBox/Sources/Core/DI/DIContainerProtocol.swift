//
//  DIContainerProtocol.swift
//  UMC_MegaBox
//

import Foundation

/// ViewModel에서 DIContainer에 의존할 때 프로토콜 타입으로 받아 DIP 준수
protocol DIContainerProtocol: AnyObject, Observable {
    var selectedTab: Int { get set }
    func resetAll()
}
