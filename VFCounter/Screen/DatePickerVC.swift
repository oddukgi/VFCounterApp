//
//  DatePickerVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/10.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


protocol DatePickerVCDelegate: class {
   func selectDate(date: String)
}

class DatePickerVC: UIViewController {

    let containerView = VFContainerView()
    let now = Date()
    
    lazy var lblDateTime: VFTitleLabel = {
        let label = VFTitleLabel()
        label.textAlignment = .center
        label.font = NanumSquareRound.bold.style(sizeOffset: 15)
        return label
        
    }()
    

    let pickerView = UIDatePicker()
    weak var delegate: DatePickerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createDismissGesture()
    }
 
    init(delegate: DatePickerVCDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Animate blackView opacity to 1 to give some depth
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)

        })
    }
    
    private func configure() {
        
        view.addSubViews(containerView, lblDateTime, pickerView)
        containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(270)
        }

        pickerView.timeZone = TimeZone.current
        pickerView.locale =  Locale(identifier: "ko_KR")
        pickerView.addTarget(self, action: #selector(changedDateTime), for: .valueChanged)
        
        lblDateTime.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(40)
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(containerView)
            make.width.equalTo(containerView)
            make.height.equalTo(240)
        }
        
        if lblDateTime.text == nil {
            let dateConverter = DateConverter(date: now)
            lblDateTime.text =  dateConverter.stringDT
            
        }

        pickerView.layer.borderWidth = 1
        
    }

    func createDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeVC(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func closeVC(_ sender: UITapGestureRecognizer) {
        pickerView.resignFirstResponder()
        delegate?.selectDate(date:  lblDateTime.text!)
        dismiss(animated: true)
    }

    @objc func changedDateTime(sender: UIDatePicker) {
        
        let dateConverter = DateConverter(date: sender.date)
        pickerView.date = dateConverter.dateTime
        lblDateTime.text = dateConverter.stringDT
    }

}


