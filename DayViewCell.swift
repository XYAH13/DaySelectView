//
//  DayViewCell.swift
//  test4
//
//  Created by Высоцкий Андрей on 12/30/19.
//  Copyright © 2019 Высоцкий Андрей. All rights reserved.
//

import Foundation
import UIKit

class DayViewCell: UICollectionViewCell {
    var dayView: DayView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.dayView = DayView.fromNib()
        self.addSubview(self.dayView)
        self.dayView.translatesAutoresizingMaskIntoConstraints = false
        self.dayView.addConstraintsStickSuperviewTo(edges: [.top, .left, .right, .bottom])
    }
}
