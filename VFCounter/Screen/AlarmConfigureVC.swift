//
//  AlarmConfigureVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/07.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

enum CellIdentifier: String {
    
    case VegieSwitchCell = "VegieSwitchCell"
    case VegieSliderCell = "VegieSliderCell"
    case VegieDatePickerCell = "VegieDatePickerCell"
    case VegieTimePickerCell = "VegieTimePickerCell"
    
    case FruitsSwitchCell = "FruitsSwitchCell"
    case FruitsSliderCell = "FruitsSliderCell"
    case FruitsDatePickerCell = "FruitsDatePickerCell"
    case FruitsTimePickerCell = "FruitsTimePickerCell"
    
    var reuseIdentifier: String {
        return rawValue
    }
}

protocol CalendarDelegate {
    func didUpdatedDates(_ selectedDate: String)
}


class AlarmConfigureVC: ModelDetailTableController {
    
    enum Section: Int {
        case vegies = 0, fruits
        
        func description() -> String {
            switch self {
            case .vegies:
                return "야채"
            case .fruits:
                return "과일"
            }
        }      
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCell()  
    }
 
    func registerCell() {
        
        tableView.register(ModelSwitchCell.self, forCellReuseIdentifier: CellIdentifier.VegieSwitchCell.reuseIdentifier)
        tableView.register(ModelSliderCell.self, forCellReuseIdentifier: CellIdentifier.VegieSliderCell.reuseIdentifier)
        tableView.register(ModelDateCell.self,   forCellReuseIdentifier: CellIdentifier.VegieDatePickerCell.reuseIdentifier)
        tableView.register(ModelPickerCell.self, forCellReuseIdentifier: CellIdentifier.VegieTimePickerCell.reuseIdentifier)
    
    }

    override func updateEdit() {
        super.updateEdit()
        
    }
    
    
// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKind = Section(rawValue: section)
        return sectionKind?.description()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func configure<T: ModelTableCell>(_ cellType: T.Type, for indexPath: IndexPath, id: CellIdentifier) -> T {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }

        cell.context(effectiveContext, owner: self)
        cell.accessoryView?.context(effectiveContext, owner: self)
        cell.editingAccessoryView?.context(effectiveContext, owner: self)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = indexPath.item
        switch item {
            
        case 0:
            let cell = configure(ModelSwitchCell.self, for: indexPath, id: .VegieSwitchCell)
            cell.textLabel?.text = "알림설정"
            return cell
            
        case 1:
            let cell = configure(ModelSliderCell.self, for: indexPath, id: .VegieSliderCell)
            cell.path = "%달성도:,percent,%%"
            cell.valuePath = "percent"
            cell.minValuePath = "#0"
            cell.maxValuePath = "#100"

            return cell
        case 2:
            return configure(ModelDateCell.self, for: indexPath, id: .VegieDatePickerCell)
        default:
            return configure(ModelPickerCell.self, for: indexPath, id: .VegieTimePickerCell)
        }
    
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func onTap(indexPath: IndexPath) {
        super.onTap(indexPath: indexPath)
    }
    
    override func onAccessoryTap(indexPath: IndexPath) {
        super.onAccessoryTap(indexPath: indexPath)
    }

}
  
    

    


















  
/*
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

    // Configure the cell...

    return cell
}
*/

/*
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
}
*/

/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
}
*/

/*
/// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/


