//
//  DaySelectView.swift
//  test4
//
//  Created by Высоцкий Андрей on 12/28/19.
//  Copyright © 2019 Высоцкий Андрей. All rights reserved.
//

import Foundation
import UIKit

class DaySelectView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datesDataSource = DayDatesDataSource()
    var selectedDayDate = Date() {
        didSet {
            self.selectDateClosure?(self.selectedDayDate)
            print(self.selectedDayDate)
        }
    }
    
    var selectDateClosure: ((Date) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedDayDate = self.datesDataSource.datesArr.first ?? Date()
        self.collectionView.register(DayViewCell.self, forCellWithReuseIdentifier: "DayViewCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = self.frame.width
        let cellWidth = (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width ?? 20
        let insets = UIEdgeInsets(top: 0, left: viewWidth / 2 - cellWidth / 2, bottom: 0, right: viewWidth)
        self.collectionView.contentInset = insets
        guard let selectedCellIndex = self.datesDataSource.datesArr.firstIndex(of: self.selectedDayDate) else {return}
        collectionView.scrollToItem(at: IndexPath(row: selectedCellIndex, section: 0), at: .left, animated: true)
    }
}

extension DaySelectView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datesDataSource.datesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayViewCell", for: indexPath) as? DayViewCell else {
            fatalError()
        }
        let date = self.datesDataSource.datesArr[indexPath.row]
        cell.dayView.setUp(date: date)
        if self.selectedDayDate == date {
            cell.dayView.selected = true
        } else {
            cell.dayView.selected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex
        {
            self.datesDataSource.generateMoreDates()
            let indexPathsArrToUpdate = ((indexPath.row + 1)...(self.datesDataSource.datesArr.count - 1)).map({
                return IndexPath(item: $0, section: 0)
            })
            DispatchQueue.main.async {
                collectionView.insertItems(at: indexPathsArrToUpdate)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDayDate = self.datesDataSource.datesArr[indexPath.row]
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.reloadData()
    }
}

class DayDatesDataSource {
    var datesArr = [Date]()
    var firstDate = Date()
    
    init() {
        let calendar = Calendar.current
        let startOfMonthDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: firstDate),
                                           month: calendar.component(.month, from: firstDate))) ?? firstDate
        let daysRange = calendar.range(of: .day, in: .month, for: startOfMonthDate) ?? Range(1...30)
        var dayDatesOfMonth = [Date]()
        for dayNumber in daysRange {
            let date = calendar.date(bySetting: .day, value: dayNumber, of: startOfMonthDate) ?? Date()
            guard date < self.firstDate else {break}
            dayDatesOfMonth.append(date)
        }
        self.datesArr.append(contentsOf: dayDatesOfMonth.reversed())
        self.firstDate = startOfMonthDate
    }
    
    func generateMoreDates() {
        let calendar = Calendar.current
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: self.firstDate) ?? Date()
        let daysRange = calendar.range(of: .day, in: .month, for: previousMonthDate) ?? Range(1...30)
        let dayDatesOfMonth = daysRange.map({dayNumber in
            return calendar.date(bySetting: .day, value: dayNumber, of: previousMonthDate) ?? Date()
        })
        self.datesArr.append(contentsOf: dayDatesOfMonth.reversed())
        self.firstDate = previousMonthDate
    }
}

class ReversedCollectionFlowLayout: UICollectionViewFlowLayout {
    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        return .rightToLeft
    }
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}
