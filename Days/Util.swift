//
//  Util.swift
//  Days
//
//  Created by Tamas Bara on 13.04.19.
//  Copyright © 2019 Tamas Bara. All rights reserved.
//

import UIKit

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safeIndex index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Date {
    func diff(to date: Date) -> String {
        let diff = Int(timeIntervalSince(date))
        
        guard diff > 0 else {return ""}
        
        let remainder = 31*86400 - diff
        
        switch remainder {
        case 1:
            return "noch 1 Sekunde"
        case 2..<60:
            return "noch \(remainder) Sekunden"
        case 60..<120:
            return "noch 1 Minute"
        case 120..<3600:
            return "noch \(remainder/60) Minuten"
        case 3600..<7200:
            return "noch 1 Stunde"
        case 7200..<86400:
            return "noch \(remainder/3600) Stunden"
        case 86400..<172800:
            return "noch 1 Tag"
        default:
            return "noch \(remainder/86400) Tage"
        }
    }
}

extension Sequence {
    func single(where condition: ((Element) throws -> Bool)) rethrows -> Element? {
        var singleElement: Element?
        for element in self where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }
}

extension UIViewController {
    func getChildVC<T>() -> T? {
        return children.single(where: {$0 is T}) as? T
    }
}
