//
//  DayView.swift
//  test4
//
//  Created by Высоцкий Андрей on 12/28/19.
//  Copyright © 2019 Высоцкий Андрей. All rights reserved.
//

import Foundation
import UIKit

class DayView: UIView {
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    var selected = false {
        didSet {
            if self.selected {
                self.dayLabel.textColor = .white
                self.monthLabel.textColor = .white
                self.gradientView.startColor = #colorLiteral(red: 0.007843137255, green: 0.5450980392, blue: 0.9921568627, alpha: 1)
                self.gradientView.endColor = #colorLiteral(red: 0.01176470588, green: 0.3215686275, blue: 0.9921568627, alpha: 1)
            } else {
                self.dayLabel.textColor = #colorLiteral(red: 0, green: 0.09803921569, blue: 0.3019607843, alpha: 1)
                self.monthLabel.textColor = #colorLiteral(red: 0, green: 0.09803921569, blue: 0.3019607843, alpha: 1)
                self.gradientView.startColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
                self.gradientView.endColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
            }
        }
    }
    
    func setUp(date: Date) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let dayNumber = calendar.component(.day, from: date)
        let monthName = dateFormatter.string(from: date)
        self.dayLabel.text = "\(dayNumber)"
        self.monthLabel.text = monthName
    }
}
