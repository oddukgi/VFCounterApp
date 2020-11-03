//
//  PickItemModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

// 총합과 비교하여, 추가할 수 있는 양이 있는지 알려주기
class PickItemModel {
    
    var config: ValueConfig?
    
    init(config: ValueConfig) {
        self.config = config
    }
    func compareAmount(amount: Int, type: String) -> Int {

        let config = self.config!
        var remain = 0
        var sum = 0
        var maxValue = 0
        var max = 0
          
        if type == "야채" {
            max = config.maxVeggies
            sum = config.sumVeggies
            
        } else {
            max = config.maxFruits
            sum = config.sumFruits
        }
        var simulatedSum =  sum + amount
        remain = max - sum
        
        if (simulatedSum > max) && amount > 0 {
            return remain
        }
            
        return 0
    }
}
