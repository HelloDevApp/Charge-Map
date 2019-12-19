//
//  ArrayExtension.swift
//  Charge_Map
//
//  Created by Macbook pro on 25/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//


extension Array where Element: Equatable {
    func removeDuplicates() -> Array {
        var newArray = Array()
        
        for element in self {
            if newArray.contains(element) == false {
                newArray.append(element)
            }
        }
        
        return newArray
    }
}
