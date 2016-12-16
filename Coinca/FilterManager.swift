//
//  FilterManager.swift
//  Coinca
//
//  Created by ParkSunJae on 16/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation

private let filterIndexKey = "filterIndex"

class FilterManager {
    fileprivate let list = [
        ("😬", NoFilter()),
        ("🐨", KoalaFilter()),
        ("🤔", Proto1Filter()),
        ("🕵", Proto2Filter())
        ]
        as [(String, Filterable)]
    
    fileprivate var index: Int = 0 {
        didSet {
            changedCurrentFilter?(current.0, current.1)
        }
    }
    
    typealias FilterHandler = (_: String, _: Filterable) -> Void
    var changedCurrentFilter: FilterHandler?
    
    var current: (String, Filterable) {
        return list[index]
    }
    
    init() {
        guard let defaultIndex = UserDefaults.standard.value(forKey: filterIndexKey) as? Int else { return }
        
        index = defaultIndex
    }
    
    func next() {
        index =  (index + 1) % list.count
        
        UserDefaults.standard.set(index, forKey: filterIndexKey)
    }
}
