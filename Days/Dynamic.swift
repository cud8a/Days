//
//  Dynamic.swift
//  Swissy
//
//  Created by Tamas Bara on 03.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: ((T) -> Void)?) {
        self.listener = listener
        listener?(value)
    }
}
