//
//  QUICStateDescriptorKey.swift
//  QUIckControl
//
//  Created by Denis Koryttsev on 06/11/16.
//  Copyright © 2016 Denis Koryttsev. All rights reserved.
//

import UIKit

protocol QUIckControlTargetProtocol {
    func setValue(_ value: Any?, forKeyPath keyPath: String)
    func isEqual(_ object: Any?) -> Bool
}

extension NSObject: QUIckControlTargetProtocol {}

protocol QUICStateDescriptor: Hashable {
    var priority: Int { get }
    var state: UIControlState { get }
    func evaluate(_ controlState: UIControlState) -> Bool
}

enum QUICStateType : Int16 {
    case usual
    case intersected
    case inverted
    case oneOfSeveral
    case noneOfThis
    case custom
}

struct QUICState: QUICStateDescriptor {
    let priority: Int
    let state: UIControlState
    let type: QUICStateType
    private let evaluateFunction: (_ state: UIControlState) -> Bool
    var hashValue: Int { return Int(state.rawValue) * priority }
    
    init(priority: Int, function: @escaping (_ state: UIControlState) -> Bool) {
        self.init(state: .normal, type: .custom, priority: priority, function: function)
    }
    
    init(state: UIControlState, type: QUICStateType) {
        self.init(state: state, type: type, priority: QUICState.priorityFor(stateType: type), function: nil)
    }
    
    private init(state: UIControlState, type: QUICStateType, priority: Int, function: ((_ state: UIControlState) -> Bool)?) {
        self.priority = priority
        self.state = state
        self.type = type
        switch (type) {
        case .usual:
            evaluateFunction = { state == $0 }
        case .inverted:
            evaluateFunction = { $0 != .normal && (state.rawValue & $0.rawValue) != state.rawValue }
        case .intersected:
            evaluateFunction = { (state.rawValue & $0.rawValue) == state.rawValue }
        case .oneOfSeveral:
            evaluateFunction = { (state.rawValue & $0.rawValue) != 0 }
        case .noneOfThis:
            evaluateFunction = { (state.rawValue & $0.rawValue) == 0 }
        case .custom:
            evaluateFunction = function ?? { _ in return true }
        }
    }
    
    func evaluate(_ controlState: UIControlState) -> Bool {
        return evaluateFunction(controlState)
    }
    
    static public func ==(lhs: QUICState, rhs: QUICState) -> Bool {
        return lhs.state == rhs.state && lhs.priority == rhs.priority
    }
    
    private static func priorityFor(stateType type: QUICStateType) -> Int {
        switch type {
        case .usual: return 1000
        case .intersected: return 999
        case .inverted: return 750
        case .oneOfSeveral, .noneOfThis: return 500
        default: return 250
        }
    }
}
