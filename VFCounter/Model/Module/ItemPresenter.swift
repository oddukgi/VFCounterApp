//
//  ItemPresenter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/29.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreStore

class ItemPresenter: StorageInjected {
    
    private weak var view: UserItemVC?
    private var date: String
    private var publisher: ListPublisher<Category>?
    
    init(view: UserItemVC, date: String) {
        self.view = view
        self.date = date
        self.publisher = storage.dataStack.publishList(From<Category>()
                        .sectionBy(\.$type).orderBy(.descending(\.$createdDate)))
    }
    
    deinit {
        publisher?.removeObserver(self)
    }
    
    func loadData() {
        
        publisher?.addObserver(self) { [weak self] listPublisher in
            guard let self = self else { return }
            let snapshot = listPublisher.snapshot
            self.view?.update(with: snapshot, date: self.date, flag: true)
        }
        if let snapshot = publisher?.snapshot {
            view?.update(with: snapshot, date: self.date)
        }
    }

    func createEntity(item: Items, config: ValueConfig) {
        
        let date = item.entityDT?.changeDateTime(format: .dateTime).extractDate
        storage.dataStack.perform(asynchronous: { transaction in
            let category = transaction.create(Into<Category>())
            
            category.name = item.name
            category.date = date
            category.createdDate = item.entityDT
            category.image = item.image?.pngData()
            category.amount = item.amount
            
            print("Entity: Category : \(category.type)")
            (category.type == "야채") ? (category.max = config.maxVeggies) : (category.max = config.maxFruits)

        }, completion: { _ in })
        
    }
    
    // MARK: calcurate sum
    func getSumEntity(date: String) -> (Int, Int) {
        
        var sumV = 0
        var sumF = 0
        var filter = matchingDate(date: date)

        let queryDict = try! storage.dataStack.queryAttributes(
            From<Category>(),
            Select("amount", .sum("amount", as: "total")), filter)
        
        for item in queryDict {
            if let type = item["type"] as? String {
                
                if type == "야채" {
                    sumV = item["total"] as? Int ?? 0
                } else {
                    sumF = item["total"] as? Int ?? 0
                }
            }
        }
        
        return (sumV, sumF)
    }
    
    func matchingDate(date: String) -> Where<Category> {
        return (\.$date == date)
    }
}
