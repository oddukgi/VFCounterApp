//
//  VFCircularView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFCircularView: UIView {

    // TODO: create circular view & calculate the value of each item

    // circle
    lazy var veggieCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        view.mainColor = RingColor.ringGreen
        view.ringColor = RingColor.ringGreen
        return view
    }()

    lazy var fruitsCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        view.mainColor = RingColor.ringYellow
        view.ringColor = RingColor.ringYellow
        return view
    }()

    lazy var lbveggie: VFBodyLabel = {
        let lbl = VFBodyLabel(textAlignment: .center,
                              font: NanumSquareRound.regular.style(offset: 13),
                              fontColor: ColorHex.brownGrey)
        lbl.text = "야채"
        lbl.numberOfLines = 0
        return lbl
    }()

    lazy var lbFruits: VFBodyLabel = {
        let lbl = VFBodyLabel(textAlignment: .center,
                              font: NanumSquareRound.regular.style(offset: 13),
                              fontColor: ColorHex.brownGrey)
 
        lbl.text = "과일"
        lbl.numberOfLines = 0
        return lbl
    }()

    // value
    lazy var totVeggieLabel: VFBodyLabel = {
        let lbl = VFBodyLabel(textAlignment: .center,
                              font: NanumSquareRound.bold.style(offset: 13.5),
                              fontColor: .black)
        lbl.numberOfLines = 0
        return lbl
    }()

    lazy var totFruitLabel: VFBodyLabel = {
        let lbl = VFBodyLabel(textAlignment: .center,
                              font: NanumSquareRound.bold.style(offset: 13.5),
                              fontColor: .black)
        lbl.numberOfLines = 0
        return lbl
    }()

    var horizontalStackView = [UIStackView]()
    var ringView: MainRingView!
    private var privateMaxVeggie = 0
    private var privateMaxFruit = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCircularView()
        setsubviewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateValue(veggieSum: Int, fruitSum: Int, date: String) {

        let type = ["야채", "과일"]
        // 날짜에 저장된 최댓값이 있는지 보기
        let vMax = CoreDataManager.queryMax(date: date, type: type[0])
        let fMax = CoreDataManager.queryMax(date: date, type: type[1])
        
        let maxVeggie = (vMax == 0) ? Int(ringView.maxVeggies) : vMax
        let maxFruit = (fMax == 0) ? Int(ringView.maxFruits) : fMax
        ringView.ringProgressView.ring1.progress = Double(veggieSum) / Double(maxVeggie)
        ringView.ringProgressView.ring2.progress = Double(fruitSum) / Double(maxFruit)

        totVeggieLabel.text = "\(veggieSum)g / \(maxVeggie)g"
        totFruitLabel.text =  "\(fruitSum)g / \(maxFruit)g"
    }
    
    func getMaxValueFromDate(date: String) {
        
    }
    func updateMaxValue(tag: Int) {
        let maxVeggie = Int(ringView.maxVeggies)
        let maxFruit = Int(ringView.maxFruits)

        var totVeggie = totVeggieLabel.text ?? ""
        var totFruits = totFruitLabel.text ?? ""

        if tag == 0 {
            var arrayV = totVeggie.components(separatedBy: "/")
            arrayV[1] = " \(maxVeggie)g"
            totVeggieLabel.text = arrayV.joined(separator: "/")
        } else {

            var arrayF = totFruits.components(separatedBy: "/")
            arrayF[1] = " \(maxFruit)g"
            totFruitLabel.text = arrayF.joined(separator: "/")
        }
    }
}
