//
//  CalendarMonthCollectionCell.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/4/26.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class CalendarMonthCollectionCell: UICollectionViewCell {
    
    var dayDidSelectedClosure: ((CalendarDay) -> Void)?
    
    var preference: CalendarPreference!
    
    var calendarMonth: CalendarMonth? {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    fileprivate var selectedIndexPath: IndexPath?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.estimatedItemSize = CGSize(width: self.bs.width/7,
                                              height: 40)
        flowLayout.headerReferenceSize = CGSize(width: self.bs.width, height: 1/UIScreen.main.scale)
        
        let c : UICollectionView = UICollectionView(frame: self.bounds,
                                                    collectionViewLayout: flowLayout)
        c.register(CalendarDayCollectionCell.self,
                        forCellWithReuseIdentifier: "CalendarDayCollectionCell")
        c.register(CalendarDayCollectionReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarDayCollectionReusableHeaderView")
        c.dataSource = self
        c.delegate = self
        c.backgroundColor = UIColor.clear
        c.isScrollEnabled = false
        return c
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarMonthCollectionCell: UICollectionViewDataSource {
    
    var daysCount: Int {
        guard let daysCount = calendarMonth?.days.count else {
            return 0
        }
        return daysCount
    }
    
    var sectionsCount: Int {
        return Int(ceil(Double(daysCount)/7))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCollectionCell", for: indexPath) as! CalendarDayCollectionCell
        
        cell.preference = preference
        cell.calendarDay = calendarMonth!.days[indexPath.section * 7 + indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarDayCollectionReusableHeaderView", for: indexPath)
            let headerView = view as! CalendarDayCollectionReusableHeaderView
            headerView.separatorStyle = preference.separatorStyle
            headerView.lineLayer.strokeColor = preference.separatorColor.cgColor
        }
        return view
    }
}

extension CalendarMonthCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bs.width/7, height: preference.dayRowHeight)
    }
}

extension CalendarMonthCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCollectionCell,
            let calendarDay = cell.calendarDay else {
            return
        }
        
        if calendarDay.isCurrentMonthDate {
            guard preference.isCurrentMonthDaySelectable else {
                return
            }
        } else if calendarDay.isPreviousMonthDate {
            guard preference.isPreviousMonthDaySelectable else {
                return
            }
        } else if calendarDay.isNextMonthDate {
            guard preference.isNextMonthDaySelectable else {
                return
            }
        } else if Calendar.autoupdatingCurrent.isDateInWeekend(calendarDay.date) {
            guard preference.isWeekendDaySelectable else {
                return
            }
        }
        
        calendarDay.isSelected = true
        cell.calendarDay = calendarDay
        
        dayDidSelectedClosure?(calendarDay)
        
        if let lastSelectedIndexPath = selectedIndexPath,
            lastSelectedIndexPath != indexPath,
            let lastSelectedCell = collectionView.cellForItem(at: lastSelectedIndexPath) as? CalendarDayCollectionCell {
            
            let lastSelectedCalendarDay = lastSelectedCell.calendarDay
            lastSelectedCalendarDay?.isSelected = false
            lastSelectedCell.calendarDay = lastSelectedCalendarDay
        }
        selectedIndexPath = indexPath
    }
}

