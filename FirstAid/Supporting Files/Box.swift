//
//  Box.swift
//  FirstAid
//
//  Created by Anna Shanidze on 01.02.2022.
//

import Foundation

class Box<T> {

    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ closure: @escaping (T) -> Void) {
        listener = closure
       // closure(value)
    }
}
