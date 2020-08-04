//
//  DYScrollRulerView.swift
//  YKScrollRulerSwift
//
//  Created by Daniel Yao on 16/11/22.
//  Copyright © 2016年 Daniel Yao. All rights reserved.
//

import UIKit

fileprivate let TextRulerFont    = UIFont.systemFont(ofSize: 13)
fileprivate let RulerLineColor   = UIColor.gray
fileprivate let RulerGap         = 18
fileprivate let RulerLong        = 40
fileprivate let RulerShort       = 30
fileprivate let TriangleWidth    = 16
fileprivate let CollectionHeight = 90
fileprivate let TextColorWhiteAlpha:CGFloat = 1.0

fileprivate func alerts(vc:UIViewController,str:String){
    let alert = UIAlertController.init(title: "提醒", message: str, preferredStyle: UIAlertController.Style.alert)
    let action:UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
        
    })
    alert.addAction(action)
    vc.present(alert, animated: true, completion: nil)
}

/***************DY************分************割************线***********/

class DYTriangleView: UIView {
    
    var triangleColor:UIColor?
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.set()
        UIRectFill(self.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.beginPath()
        context!.move(to: CGPoint.init(x: 0, y: 0))
        context!.addLine(to: CGPoint.init(x: TriangleWidth, y: 0))
        context!.addLine(to: CGPoint.init(x: TriangleWidth/2, y: TriangleWidth/2))
        context!.setLineCap(CGLineCap.butt)
        context!.setLineJoin(CGLineJoin.bevel)
        context!.closePath()
        
        triangleColor?.setFill()
        triangleColor?.setStroke()
        
        context!.drawPath(using: CGPathDrawingMode.fillStroke)
    }
    
}

/***************DY************分************割************线***********/

class DYRulerView: UIView {
    var minValue:Float = 0.0
    var maxValue:Float = 0.0
    var unit:String = ""
    var step:Float = 0.0
    var betweenNumber = 0
    override func draw(_ rect: CGRect) {
        let startX:CGFloat  = 0
        let lineCenterX     = CGFloat(RulerGap)
        let shortLineY      = rect.size.height - CGFloat(RulerLong) - 10
        let longLineY       = rect.size.height - CGFloat(RulerShort)
        let topY:CGFloat    = 0
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        context?.setLineCap(CGLineCap.butt)
        context?.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        for i in 0...betweenNumber {
            print(i)
            
            let value = startX + lineCenterX * CGFloat(i)
            print(value, topY)
            
            context?.move(to: CGPoint.init(x: value, y: topY))
            if i%betweenNumber == 0 {
                let num = Float(i)*step+minValue
                
                let newNum = Int(num)
                print(unit)
                var numStr = String(format: "%d%@", newNum,unit)
                if num > 1000000 {
                    numStr = String(format: "%d万%@", num/10000,unit)
                }
                print(i,step,minValue)
                let attribute:Dictionary = [NSAttributedString.Key.font:TextRulerFont,NSAttributedString.Key.foregroundColor:UIColor.init(white: TextColorWhiteAlpha, alpha: 1.0)]
                
                let width = numStr.boundingRect(
                    with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                    attributes: attribute,context: nil).size.width
                numStr.draw(in: CGRect.init(x: startX+lineCenterX*CGFloat(i)-width/2, y: longLineY+10, width: width, height: 16), withAttributes: attribute)
                context!.addLine(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i), y: longLineY))
            }else{
                context!.addLine(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i), y: shortLineY))
            }
            context!.strokePath()

        }
        
    }
}

/***************DY************分************割************线***********/

class DYHeaderRulerView: UIView {
    
    var headerMinValue = 0
    var headerUnit = ""
    
    override func draw(_ rect: CGRect) {
        let longLineY = rect.size.height - CGFloat(RulerShort)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context?.setLineWidth(1.0)
        context?.setLineCap(CGLineCap.butt)
        
        context?.move(to: CGPoint.init(x: rect.size.width, y: 0))
        var numStr:NSString = NSString(format: "%d%@", headerMinValue,headerUnit)
        if headerMinValue > 1000000 {
            numStr = NSString(format: "%f万%@", headerMinValue/10000,headerUnit)
        }
        let attribute:Dictionary = [NSAttributedString.Key.font:TextRulerFont,NSAttributedString.Key.foregroundColor:UIColor.init(white: TextColorWhiteAlpha, alpha: 1.0)]
        let width = numStr.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numStr.draw(in: CGRect.init(x: rect.size.width-width/2, y: longLineY+10, width: width, height: 16), withAttributes: attribute)
        context?.addLine(to: CGPoint.init(x: rect.size.width, y: longLineY))
        context?.strokePath()
        
    }
}

/***************DY************分************割************线***********/

class DYFooterRulerView: UIView {
    var footerMaxValue = 0
    var footerUnit = ""
    
    override func draw(_ rect: CGRect) {
        let longLineY = Int(rect.size.height) - RulerShort
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context?.setLineWidth(1.0)
        context?.setLineCap(CGLineCap.butt)
        
        context?.move(to: CGPoint.init(x: 0, y: 0))
        var numStr:NSString = NSString(format: "%d%@", footerMaxValue,footerUnit)
        if footerMaxValue > 1000000 {
            numStr = NSString(format: "%d万%@", Int(footerMaxValue/10000),footerUnit)
        }
        let attribute:Dictionary = [NSAttributedString.Key.font:TextRulerFont,NSAttributedString.Key.foregroundColor:UIColor.init(white: TextColorWhiteAlpha, alpha: 1.0)]
        let width = numStr.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numStr.draw(in: CGRect.init(x: 0-width/2, y: CGFloat(longLineY+10), width: width, height:CGFloat(16)), withAttributes: attribute)
        context?.addLine(to: CGPoint.init(x: 0, y: longLineY))
        context?.strokePath()
    }
}

/***************DY************分************割************线***********/

protocol DYScrollRulerDelegate:NSObjectProtocol {
    func dyScrollRulerViewValueChange(rulerView:DYScrollRulerView,value:Float)
}
class DYScrollRulerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate:DYScrollRulerDelegate?
    
    var scrollByHand = true
    var triangleColor:UIColor? = nil
    var bgColor:UIColor? = nil
    var stepNum = 0//分多少个大区

    private var redLine:UIImageView?
    private var fileRealValue:Int = 0
    var rulerUnit:String = ""
    var minValue:Float = 0.0
    var maxValue:Float = 0.0
    var step:Float = 0.0 //间隔值，每两条相隔多少值
    var betweenNum:Int = 0
    
    var currentVC:UIViewController?
    
    
    
    class func rulerViewHeight() -> Int {
        return 40+20+CollectionHeight
    }
    
    init(frame: CGRect,tminValue:Float,tmaxValue:Float,tstep:Float,tunit:String,tNum:Int,viewcontroller:UIViewController) {
        super.init(frame: frame)
        minValue    = tminValue
        maxValue    = tmaxValue
        betweenNum  = tNum
        step        = tstep
        stepNum     = Int((tmaxValue - tminValue)/step)/betweenNum
        rulerUnit   = tunit
        bgColor     = UIColor.white
        currentVC   = viewcontroller
        
        triangleColor = UIColor.orange
        self.backgroundColor    = UIColor.white
        
        lazyValueTF.frame       = CGRect.init(x: self.bounds.size.width/2 - 80, y: 2, width: 80, height: 40)
        self.addSubview(self.lazyValueTF)

        lazyTriangle.frame      = CGRect.init(x: (self.bounds.size.width/2) - SizeManager().trianglePos - CGFloat(TriangleWidth)/2, y: lazyValueTF.frame.maxY, width: CGFloat(TriangleWidth), height: CGFloat(TriangleWidth))
        lazyUnitLab.frame       = CGRect.init(x: lazyValueTF.frame.maxX+10, y: lazyValueTF.frame.minY, width: 40, height: 40)
        lazyOKBtn.frame         = CGRect.init(x: lazyUnitLab.frame.maxX+10, y: lazyValueTF.frame.minY+5, width: 40, height: 30)
        
        self.backgroundColor = ColorHex.lightKhaki
        self.layer.borderWidth = 1
        self.addSubview(self.lazyUnitLab)
        self.addSubview(self.lazyOKBtn)
        self.addSubview(self.lazyCollectionView)
        self.addSubview(self.lazyTriangle)

        self.lazyCollectionView.frame = CGRect.init(x: 0, y:self.lazyValueTF.frame.maxY, width: self.bounds.size.width, height: CGFloat(CollectionHeight))
        self.lazyUnitLab.text = tunit
        
//        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lazyValueTF: UITextField = {[unowned self] in
        let zyValueTF = UITextField()
        zyValueTF.isUserInteractionEnabled  = true
        zyValueTF.defaultTextAttributes     = [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 19)]
        zyValueTF.textAlignment = NSTextAlignment.right
        zyValueTF.delegate      = self
        zyValueTF.keyboardType  = UIKeyboardType.numbersAndPunctuation
        zyValueTF.returnKeyType = UIReturnKeyType.done
        zyValueTF.textAlignment = .center
        
        return zyValueTF
    }()
    lazy var lazyOKBtn:UIButton = {
        let okBtn = UIButton.init(type: UIButton.ButtonType.custom)
        okBtn.setTitle("OK", for: UIControl.State.normal)
        okBtn.setTitleColor(UIColor.init(white: 0.7, alpha: 1.0), for: UIControl.State.highlighted)
        okBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        okBtn.addTarget(self, action: #selector(DYScrollRulerView.editDone), for: UIControl.Event.touchUpInside)
        okBtn.backgroundColor = UIColor.gray
        okBtn.layer.cornerRadius = 5.0
        
        return okBtn
    }()
    lazy var lazyUnitLab: UILabel = {
        let zyUnitLab = UILabel()
        zyUnitLab.textColor = UIColor.red
        
        return zyUnitLab
    }()
    lazy var lazyCollectionView: UICollectionView = {[unowned self]in
        
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = UICollectionView.ScrollDirection.horizontal
        flowLayout.sectionInset     = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        let zyCollectionView:UICollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: CGFloat(CollectionHeight)), collectionViewLayout: flowLayout)
        zyCollectionView.backgroundColor    = RulerColor.bgColor
        zyCollectionView.bounces            = true
        zyCollectionView.showsHorizontalScrollIndicator = false
//        zyCollectionView.showsVerticalScrollIndicator   = false
        zyCollectionView.delegate   = self
        zyCollectionView.dataSource = self
        zyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "headCell")
        zyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "footerCell")
        zyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customeCell")

        return zyCollectionView
    }()
    lazy var lazyTriangle: DYTriangleView = {
        let triangleView = DYTriangleView()
        triangleView.backgroundColor = UIColor.clear
        triangleView.triangleColor = UIColor.blue
        return triangleView
    }()
    
    @objc fileprivate func didChangeCollectionValue() {
        let textFieldValue = Float(lazyValueTF.text!)
        
        let value = Int(textFieldValue!-minValue)
        print("Scrolling value: \(value)")
        if value >= 0 && value < Int(maxValue) {
            
            let value = value / Int(step)
            self.setRealValueAndAnimated(realValue: value, animated: true)
        }
    }
    
    @objc fileprivate func setRealValueAndAnimated(realValue:Int,animated:Bool){
        fileRealValue       = realValue
        
        let value = (fileRealValue) * Int(step+minValue)
        
        print(value)
        
        if value > Int(maxValue) {
//            lazyCollectionView.isScrollEnabled = false
            return
            
        }
        lazyValueTF.text    = String.init(format: "%d", value)
        lazyCollectionView.setContentOffset(CGPoint.init(x: Int(realValue)*RulerGap, y: 0), animated: animated)
    }
    
    func setDefaultValueAndAnimated(defaultValue:Int, animated:Bool){
        fileRealValue = defaultValue
        lazyValueTF.text = String.init(format: "%d", defaultValue)
        
        let newValue  = defaultValue - Int(minValue / step)
        lazyCollectionView.setContentOffset(CGPoint.init(x: newValue * RulerGap, y: 0), animated: animated)
    }
    
    @objc func editDone(){
        
        
        let currentText:NSString = lazyValueTF.text! as NSString
        if !self.judgeTextsHasWord(texts: currentText as String){
            alerts(vc: currentVC!, str: "请输入数字")
            return
        }
        lazyValueTF.resignFirstResponder()

        if currentText.floatValue > maxValue {
            lazyValueTF.text = String.init(format: "%d", Int(maxValue))
            self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 0)
        }else if currentText.floatValue <= minValue || currentText.length == 0{
            lazyValueTF.text = String.init(format: "%d", Int(minValue))
            self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 1)
        }else{
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 1)
        }
        
    }
    
    func judgeTextsHasWord(texts:String) -> Bool{
        let scan:Scanner = Scanner.init(string: texts)
       // return scan.scanFloat(&value) && scan.isAtEnd
        return (scan.scanFloat(representation: .decimal) != nil)  && scan.isAtEnd
    }
    
    func setStyle() {
        
       lazyValueTF.layer.cornerRadius = 8
       lazyValueTF.clipsToBounds = true
       lazyValueTF.layer.borderWidth = 1
       lazyValueTF.layer.borderColor = ColorHex.darkGreen.cgColor
    }
}

extension DYScrollRulerView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2+stepNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell:UICollectionViewCell       = collectionView.dequeueReusableCell(withReuseIdentifier: "headCell", for: indexPath)
            var headerView:DYHeaderRulerView?   = cell.contentView.viewWithTag(1000) as?DYHeaderRulerView
            
            if headerView == nil{
                headerView = DYHeaderRulerView.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.frame.size.width/2), height: CollectionHeight))
                headerView!.backgroundColor  = UIColor.clear
                headerView!.headerMinValue   = Int(minValue)
                headerView!.headerUnit       = rulerUnit
                headerView!.tag              = 1000
                cell.contentView.addSubview(headerView!)
            }
            return cell
        }else if indexPath.item == stepNum+1 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "footerCell", for: indexPath)
            var footerView:DYFooterRulerView? = cell.contentView.viewWithTag(1001) as? DYFooterRulerView
            if footerView == nil {
                footerView = DYFooterRulerView.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.frame.size.width/2), height: CollectionHeight))
                footerView!.backgroundColor  = UIColor.clear
                footerView!.footerMaxValue   = Int(maxValue)
                footerView!.footerUnit       = rulerUnit
                footerView!.tag              = 1001
                cell.contentView.addSubview(footerView!)
            }
            return cell
        }else{
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customeCell", for: indexPath)
            var rulerView:DYRulerView? = cell.contentView.viewWithTag(1002) as? DYRulerView
            if rulerView == nil {
                rulerView = DYRulerView.init(frame: CGRect.init(x: 0, y: 0, width: RulerGap*betweenNum, height: CollectionHeight))
                rulerView!.backgroundColor   = UIColor.clear
                rulerView!.step              = step
                rulerView!.unit              = rulerUnit
                rulerView!.tag               = 1002
                rulerView!.betweenNumber     = betweenNum;
                cell.contentView.addSubview(rulerView!)
            }
            
            rulerView?.backgroundColor = UIColor.gray
         
            rulerView!.minValue = step*Float((indexPath.item-1))*Float(betweenNum)+minValue
            rulerView!.maxValue = step*Float(indexPath.item)*Float(betweenNum)
            rulerView!.setNeedsDisplay()
 
            return cell
        }
        
    }
    
    
}
extension DYScrollRulerView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x)/RulerGap
        let totalValue = Float(value)*step+minValue
        if scrollByHand {
            if totalValue>=maxValue {
                lazyValueTF.text = String.init(format: "%d", Int(maxValue))
            }else if totalValue <= minValue {
                lazyValueTF.text = String.init(format: "%d", Int(minValue))
            }else{
                lazyValueTF.text = String.init(format: "%d", value * Int(step)+Int(minValue))
            }
        }
            delegate?.dyScrollRulerViewValueChange(rulerView: self, value: totalValue)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValueAndAnimated(realValue: Int(Float(scrollView.contentOffset.x)/Float(RulerGap)), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValueAndAnimated(realValue: Int(Float(scrollView.contentOffset.x)/Float(RulerGap)), animated: true)
    }
}
extension DYScrollRulerView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == stepNum + 1 {
            return CGSize(width: Int(self.frame.size.width/2), height: CollectionHeight)
        }
        return CGSize(width: RulerGap*betweenNum, height: CollectionHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension DYScrollRulerView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.editDone()
        return true
    }
}



