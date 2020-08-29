//
//  MontlyChartVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class MontlyChartVC: ChartBaseVC {

    let monthlyChartView = BarChartView()
    let lblMonth = VFTitleLabel(textAlignment: .center, fontSize: 15)

    
    lazy var btnLeftArrow: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "chartL")
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    
    lazy var monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 30
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
      
    private var date: String?

    
    init(date: String) {
        super.init(nibName: nil, bundle: nil)
        self.date = date // 일 수계산 (31, 28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRadioButtons()
        connectAction()
        // Do any additional setup after loading the view.
    }

    override func updateChartData() {
        
    }
    
    
    func configureRadioButtons() {
        
        view.addSubViews(monthStackView)
    



    }
        
    func connectAction() {
        monthStackView.addArrangedSubview(btnLeftArrow)
        monthStackView.addArrangedSubview(lblMonth)
        
        monthStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.centerX.equalTo(view).offset(-20)
            make.height.equalTo(30)
        }
        
        lblMonth.text = date
        btnLeftArrow.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32, height: 40))
        }
     
        lblMonth.layer.borderWidth = 1
        btnLeftArrow.layer.borderWidth = 1
    }
    
    func applyChartOption() {
        self.setup(barLineChartView: monthlyChartView)
        monthlyChartView.delegate = self
        monthlyChartView.drawBarShadowEnabled = false
        monthlyChartView.drawValueAboveBarEnabled = false
        
        let xAxis = monthlyChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        identifyChartSettings(xAxis)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 0
        leftAxisFormatter.positiveSuffix = " g"
        
        let leftAxis = monthlyChartView.leftAxis
        leftAxis.labelFont = NanumSquareRound.bold.style(sizeOffset: 13)
        leftAxis.labelCount = 8
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.3
        leftAxis.axisMinimum = 0
        
       
    }
    
    func configureMarker() {
    
        let marker = BalloonMarker(color: .white,
                                   font: NanumSquareRound.bold.style(sizeOffset: 13),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
             marker.chartView = monthlyChartView
             marker.minimumSize = CGSize(width: 100, height: 70)
             monthlyChartView.marker = marker
    }
    
    func identifyChartSettings(_ xAxis: XAxis) {

        monthlyChartView.maxVisibleCount = 31
        xAxis.labelFont = NanumSquareRound.bold.style(sizeOffset: 11)
        xAxis.valueFormatter = MonthAxisValueFormatter(chart: monthlyChartView,date: Date())
    }
    


     
}


