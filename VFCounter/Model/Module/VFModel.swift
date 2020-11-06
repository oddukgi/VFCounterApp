//
//  MainList.Model.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import CoreStore
import Foundation

 // MARK: - Veggie, Fruit, Field

 class Category: CoreStoreObject {
        // MARK: Internal
    
    @Field.Stored("identifier", dynamicInitialValue: { UUID() })
    var identifier: UUID
    
    @Field.Stored("name",
                  customSetter: { object, field, newValue in
                    let fruits = [
                        "사과", "살구", "아보카도", "바나나", "블루베리", "체리",
                        "코코넛", "용과", "포도", "자몽", "아오리", "샤인머스캣",
                        "천도복숭아", "키위", "레몬", "망고", "망고스틴", "멜론",
                        "오렌지", "복숭아", "배", "감", "파인애플", "자두",
                        "석류", "라즈베리", "딸기", "귤", "수박"
                    ]
                    field.primitiveValue = newValue
                    if let newValue = newValue {
                        object.$type.value = fruits.contains(newValue) ? "과일" : "야채"
                    } else {
                        object.$type.value = nil
                    }
                  })
    
    var name: String?
    
    @Field.Stored("type")
    var type: String?
 
    @Field.Stored("amount")
    var amount: Int = 0
    
    @Field.Stored("date")
    var date: String?
    
    @Field.Stored("createdDate")
    var createdDate: Date?
    
    @Field.Stored("image")
    var image: Data?
    
    @Field.Stored("max")
    var max: Int = 0
        
}
