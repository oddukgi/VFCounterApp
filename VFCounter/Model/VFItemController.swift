//
//  VFItemController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFItemController {

   
    struct Items: Hashable {
        var name: String
        var date: String
        var image: UIImage?
        var amount: Int
        let identifiable = UUID()
     
        func hash(into hasher: inout Hasher){
            hasher.combine(identifiable)
        }
    }
    
    
    struct VFCollections: Hashable {

        let title: String
        let subtitle: String
    }

    var collections: [VFCollections] {
        
        get {
            return _collections
        }
        set(newCollections) {
            self._collections = newCollections
        }
    }

    init() {
        generateSections()
    }
    
    fileprivate var _collections = [VFCollections]()
}

extension VFItemController {
    
    func generateSections() {
        _collections = [
                            VFCollections(title: "야채", subtitle: "야채음식,생야채가 해당됩니다."),
                            VFCollections(title: "과일", subtitle: "과일음식,주스,생과일이 해당됩니다.")
                       ]
    }
    
}
