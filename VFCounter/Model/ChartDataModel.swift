//
//  ChartDataModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/14.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class ChartDataModel {
    
    
    
    
    let chartData = [
                    try? UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.veggieConfiguration).orderBy(.descending(\.time))),
                    try? UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.fruitsConfiguration).orderBy(.descending(\.time))) ]
         
    
    init() {
        
    }
    
    var totalAmountByVeggies: Int = {
        return chartData[0].reduce(0, +)
    }
    
    var totalAmountByFruits: Int = {
        return chartData[1].reduce(0, +)
    }

    
}
