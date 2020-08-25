//
//  PickItems.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class PickItems {
    
    struct Element: Hashable {
        var name: String
        var image: UIImage?
        var amount: Int

    }
    
    struct Collections: Hashable {
        var elements: [Element]
        let identifiable = UUID()
        
        func hash(into hasher: inout Hasher){
            hasher.combine(identifiable)
        }
        
        
    }
    
    struct SinglePick: Hashable {
        var name: String
        var image: UIImage?
        var amount: Int
        var dateTime: String
        
        init() {
            name = ""
            image = nil
            dateTime  = ""
            amount = 0
        }
    }
    
    var collections: [Collections] {
          
        get {
            return _collections
        }
        set(newCollections) {
            self._collections = newCollections
        }
     }

   var item: SinglePick {
         
       get {
           return onePick
       }
       set(newItem) {
           self.onePick = newItem
       }
    }

    
    init() {
        generateveggies()
        generateFruits()      
    }
    
    fileprivate var _collections = [Collections]()
    fileprivate var onePick = SinglePick()
}

extension PickItems {
    
    func generateveggies() {
    
        var elements: [Element] = []
        let images = [
                        UIImage(named: "asparagus"),UIImage(named:"beet"),
                        UIImage(named: "broccoli"),UIImage(named: "paprika"),
                        UIImage(named:"cabbage"),
                        UIImage(named: "carrot"),   UIImage(named:"corn"),
                        UIImage(named: "cucumber"), UIImage(named:"custom veggie"),
                        UIImage(named: "eggplant"), UIImage(named:"garlic"),
                        UIImage(named: "kohlrabi"), UIImage(named:"leek"),
                        UIImage(named: "lettuce"),  UIImage(named:"mushroom"),
                        UIImage(named: "olive"),    UIImage(named:"onion"),
                        UIImage(named: "peas"),     UIImage(named:"potato"),
                        UIImage(named: "pumpkin"),  UIImage(named:"radish"),
                        UIImage(named: "salad"),    UIImage(named:"soy"),
                        UIImage(named:"sweet potato"), UIImage(named: "tomato"),
                        UIImage(named: "zucchini"), UIImage(named: "celery")
                    ]
        let koName = [
                        "아스파라거스","비트","브로콜리","파프리카",
                        "양배추","당근","옥수수",
                        "오이","사용자 설정","가지",
                        "마늘","콜라비","파,부추",
                        "상추","버섯","올리브",
                        "양파","완두콩","감자",
                        "호박","무","샐러드",
                        "콩","고구마","토마토","애호박","셀러리"
                    ]
        
        var i = 0
        for name in koName {
           
            let element = Element(name: name, image: images[i], amount: 0)
            elements.append(element)
        
            i += 1
        }
        _collections.append(Collections(elements: elements))
    }
    
    func generateFruits() {
        
        var elements: [Element] = []
        let images = [
                          UIImage(named: "apple"), UIImage(named: "apricot"), UIImage(named: "avocado"),
                          UIImage(named: "banana"), UIImage(named: "blueberry"), UIImage(named: "cherry"),
                          UIImage(named: "coconut"), UIImage(named: "dragon fruit"), UIImage(named: "grape"),
                          UIImage(named: "grapefruit"), UIImage(named: "green apple"), UIImage(named: "shine musket"),
                          UIImage(named: "heavenly peach"), UIImage(named: "kiwi"),  UIImage(named: "lemon"),
                          UIImage(named: "mango"), UIImage(named: "mangosteen"),     UIImage(named: "melon"),
                          UIImage(named: "orange"), UIImage(named: "peach"),         UIImage(named: "pear"),
                          UIImage(named: "persimmon"), UIImage(named: "pineapple"),  UIImage(named: "plum"),
                          UIImage(named: "pomegranate"), UIImage(named: "rasberry"), UIImage(named: "strawberry"),
                          UIImage(named: "tangerine"), UIImage(named:    "watermelon")
                      ]
          let koName = [
                          "사과","살구","아보카도",
                          "바나나","블루베리","체리",
                          "코코넛","용과","포도",
                          "자몽","아오리(초록사과)","샤인머스캣",
                          "천도복숭아","키위","레몬",
                          "망고","망고스틴","멜론",
                          "오렌지","복숭아","배",
                          "감","파인애플","자두",
                          "석류","라즈베리","딸기",
                          "귤","수박"
                      ]
          
        var i = 0
         for name in koName {
           
            let element = Element(name: name, image: images[i], amount: 0)
            
            elements.append(element)
            i += 1
        }
        _collections.append(Collections(elements: elements))
    }
    
    
}
