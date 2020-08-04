//
//  CustomCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


/*
 "headCell")
 "footerCell")
 "customeCell"
 
 */

protocol CellProtocol {
    static var reuseIdentifier: String { get }
    func addView(_ value: Float, _ rulerUnit: String, _ collectionHeight: Int, betweenNum: Int, rulerGap: Int,
                 item: Int, minValue: Float)
}

class HeaderCell: UICollectionViewCell, CellProtocol {
    static let reuseIdentifier = "HeaderCell"
    func addView(_ value: Float, _ rulerUnit: String,_ collectionHeight: Int, betweenNum: Int,
                 rulerGap: Int,  item: Int, minValue: Float) {
        
        var headerView: VFHeaderRulerView? = contentView.viewWithTag(1000) as? VFHeaderRulerView
        headerView = VFHeaderRulerView(frame: CGRect(x: 0, y: 0, width: (Int(frame.size.width) / 2), height: collectionHeight))
        headerView!.backgroundColor  = UIColor.clear
        headerView!.headerMinValue   = Int(value)
        headerView!.headerUnit       = rulerUnit
        headerView!.tag              = 1000
        contentView.addSubview(headerView!)
    }
}

class FooterCell: UICollectionViewCell, CellProtocol {
    
    static let reuseIdentifier = "FooterCell"
    func addView(_ value: Float, _ rulerUnit: String, _ collectionHeight: Int, betweenNum: Int,
                 rulerGap: Int, item: Int, minValue: Float) {
        var footerView: VFFooterRulerView? = contentView.viewWithTag(1001) as? VFFooterRulerView
        footerView = VFFooterRulerView(frame: CGRect(x: 0, y: 0, width: (Int(frame.size.width) / 2), height: collectionHeight))
        footerView!.backgroundColor  = UIColor.clear
        footerView!.footerMaxValue   = Int(value)
        footerView!.footerUnit       = rulerUnit
        footerView!.tag              = 1001
        contentView.addSubview(footerView!)
    }

}

class CustomCell: UICollectionViewCell, CellProtocol {
    
    static let reuseIdentifier = "CustomCell"
    
    func addView(_ value: Float, _ rulerUnit: String, _ collectionHeight: Int, betweenNum: Int,
                 rulerGap: Int, item: Int, minValue: Float) {
        var rulerView: VFRulerView? = contentView.viewWithTag(1002) as? VFRulerView
        rulerView = VFRulerView(frame: CGRect(x: 0, y: 0, width: rulerGap * betweenNum, height: collectionHeight))
        rulerView!.backgroundColor  = UIColor.clear
        rulerView!.step       = value
        rulerView!.unit   = rulerUnit
        rulerView!.betweenNumber = betweenNum
        rulerView!.tag              = 1002
        rulerView!.backgroundColor = RulerColor.bgColor
        rulerView!.minValue = value * Float(item-1) * Float(betweenNum)+Float(minValue)
        rulerView!.maxValue = value * Float(item) * Float(betweenNum)
        rulerView!.setNeedsDisplay()
        
        contentView.addSubview(rulerView!)
    }
    
}
