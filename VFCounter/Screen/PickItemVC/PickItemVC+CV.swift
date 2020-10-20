//
//  PickItemVC+CV.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension PickItemVC {

   func configureAmountLabel() {
       view.addSubview(stackView)
       stackView.addArrangedSubview(lblRemain)
       stackView.addArrangedSubview(lblTotal)
       
       stackView.snp.makeConstraints { make in
           make.top.equalTo(collectionView.snp.bottom).offset(15)
           make.centerX.equalTo(view.snp.centerX)
           make.height.equalTo(66)
       }

       lblRemain.snp.makeConstraints { make in
           make.size.equalTo(CGSize(width: 88, height: 66))
       }
       
       lblTotal.snp.makeConstraints { make in
           make.size.equalTo(CGSize(width: 88, height: 66))
       }
       
       lblRemain.backgroundColor = ColorHex.dimmedBlack
       lblTotal.backgroundColor = ColorHex.dimmedBlack
       lblRemain.layer.cornerRadius = 8
       lblTotal.layer.cornerRadius = 8
   }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: UIHelper.createColumnsLayout())
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config

        return layout
    }

   func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, PickItems.Element>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, items) -> UICollectionViewCell? in
            // Get a cell of the desired kind.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickItemCell.reuseIdentifier, for: indexPath) as? PickItemCell else {
                    fatalError("Cannot create new cell")
        }
        // 선택한 아이템을 다른 곳에 담기
        cell.contentView.backgroundColor = ColorHex.iceBlue
        cell.contentView.layer.cornerRadius = 10
        cell.setRadiusWithShadow(10)

        cell.set(items.image, items.name)
        cell.isChecked = self.checkedIndexPath.contains(indexPath)

        return cell
    })
   }

    func updateData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, PickItems.Element>()

        currentSnapshot.appendSections([.main])
        if datemodel.tag == 0 {
            currentSnapshot.appendItems(pickItems.collections.first!.elements)

        } else {
            currentSnapshot.appendItems(pickItems.collections.last!.elements)
        }

        updateCollectionView()
    }

    func storeItems(name: String, dateTime: String, image: UIImage?) {
        pickItems.item.name  = name
        pickItems.item.image = image
        pickItems.item.dateTime = dateTime
    }

    func updateCollectionView() {
         OperationQueue.main.addOperation {
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
        }
    }

    func configureSegmentControl() {

        kindSegmentControl = UISegmentedControl(items: ["야채", "과일"])
        kindSegmentControl.selectedSegmentIndex = 0
        view.addSubview(kindSegmentControl)

        kindSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        kindSegmentControl.layer.cornerRadius = 5.0
        kindSegmentControl.backgroundColor = ColorHex.iceBlue
        kindSegmentControl.tintColor = ColorHex.lightBlue
        kindSegmentControl.addTarget(self, action: #selector(changedIndexSegment), for: .valueChanged)
    }

    @objc func changedIndexSegment(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            datemodel.tag = 0

        default:
            datemodel.tag = 1

        }
        updateNaviTitle(to: datemodel.tag)
        updateData()
        updateRemainTotalText()
    }

    // MARK: - update text showing (remain, total)
    func updateRemainTotalText() {

        let title = ["추가할 무게\n", "최대 무게\n"]
        var value = ""
        switch datemodel.tag {
        case 0:
            let remain = datemodel.maxV - datemodel.sumV
            lblRemain.text = title[0] + "\(remain)g"
            lblTotal.text = title[1] + "\(datemodel.maxV)g"
       
        default:
            let remain = datemodel.maxF - datemodel.sumF
            lblRemain.text = title[0] + "\(remain)g"
            lblTotal.text = title[1] + "\(datemodel.maxF)g"
        }
    }
}

extension PickItemVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickItemCell else { return }

        checkedIndexPath.removeAll()
        cell.isChecked = false

        updateCollectionView()
        checkedIndexPath.insert(indexPath)
        cell.isChecked = true

        let name = cell.lblName.text ?? ""
        let image = cell.itemImage.image

        storeItems(name: name, dateTime: datemodel.date, image: image)
    }
}

extension PickItemVC: UserDateTimeDelegate {
    func updateMaxAmount(date: Date) {
        let dt = date.changeDateTime(format: .date)
        checkMaxValueFromDate(date: dt)
        updateRemainTotalText()

        NotificationCenter.default.post(name: .updateTaskPercent, object: nil, userInfo: ["veggieAmount": datemodel.maxV])

        NotificationCenter.default.post(name: .updateTaskPercent, object: nil, userInfo: ["fruitAmount": datemodel.maxF])
    }
}
