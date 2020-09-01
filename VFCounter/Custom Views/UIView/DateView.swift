//
//  DateView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit


class DateView: UIView {

    var btnLeftArrow: VFButton!
    var btnRightArrow: VFButton!
    let weatherIcon = WeatherIconView(frame: .zero)
  
    var horizontalView: [UIStackView] = []
    let dateLabel = VFTitleLabel(textAlignment: .center, fontSize: 16)
    let weatherLabel = VFSubTitleLabel(fontSize: 14)
    let commentLabel = VFBodyLabel(textAlignment: .left, fontSize: 13, fontColor: ColorHex.dullOrange)
    private var date = Date()
    private var startDate: Date?
    private var endDate: Date?

    lazy var btnLocation: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "location")
        return button
    }()
    
    lazy var commentIcon: UIImageView = {
        let image = UIImage(named: "strawberry")?.imageByMakingWhiteBackgroundTransparent()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        setLayout()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        
        let dateconverter = DateConverter(date: date)
        dateLabel.text = dateconverter.changeDate(format:"yyyy.MM.dd E", option: 1)
        dateLabel.textColor = UIColor.black
        weatherLabel.text = ""
        commentLabel.numberOfLines = 0
        commentLabel.text = """
                            좋은 아침!
                            사과를 섭취하면, 몸이 활력이 생겨요
                            """
        
        btnLeftArrow.addTarget(self, action: #selector(changedDateTouched), for: .touchUpInside)
        btnLeftArrow.tag = 0
        btnRightArrow.addTarget(self, action: #selector(changedDateTouched), for: .touchUpInside)
        btnRightArrow.tag = 1
        
        startDate = date.getFirstMonthDate()
        endDate = date.addDaysToday(days: 0)

    }
    
    
    @objc func changedDateTouched(_ sender: VFButton) {
    
    
        if sender.tag == 0 {

            if date > startDate! {
                date = date.dayBefore.endOfDay()
                let beforeDate = DateConverter(date: date).changeDate(format: "yyyy.MM.dd E", option: 1)
                dateLabel.text = beforeDate
                NotificationCenter.default.post(name: .updateFetchingData, object: nil, userInfo: ["createdDate": beforeDate])
                
            }
            
        } else {
            
            if date < endDate! {
                date = date.dayAfter.endOfDay()
                let afterDate = DateConverter(date: date).changeDate(format: "yyyy.MM.dd E", option: 1)
                dateLabel.text = afterDate
                NotificationCenter.default.post(name: .updateFetchingData, object: nil, userInfo: ["createdDate": afterDate])
               

            }

        }
//        print(date)
        
    }

    
    func updateDate(userdate: String) {
        
        date = userdate.changeDateTime(format: .date)
        if date > startDate! {
             changedDateTouched(btnLeftArrow)
        }
        
        if date < endDate! {
            changedDateTouched(btnRightArrow)
        }
        
    }
}
