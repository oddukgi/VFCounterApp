//
//  ElementDataSource.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class ElementDataSource: NSObject, UITableViewDataSource {
    
    var dates = [String]()
    var weekday = Array<String>()
    
    func checkDate() {
        var items = Set<String>()
        let dataManager = DataManager()
        dates.forEach { (date) in
            
            let item = date.components(separatedBy: " ").first
            
            dataManager.isDataEmpty(date: item!) { (veggieName, fruitName) in
            
              if veggieName != nil {
                    items.insert(date)
                    
                }
                
              if fruitName != nil {
                  items.insert(date)
              }
            }
        }
        
        weekday = Array(items).sorted()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weekday.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weekday[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ElementCell.reuseIdentifier, for: indexPath) as! ElementCell
        let newDate = weekday[indexPath.section].components(separatedBy: " ")[0]
        cell.updateDate(newDate)
      
        return cell
    }

}
