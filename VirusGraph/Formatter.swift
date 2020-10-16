//
//  Formatter.swift
//  VirusGraph
//
//  Created by AdrenResi on 10/14/20.
//

import Foundation
import Charts

class ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print(value)
        let date = Date(timeIntervalSince1970: value)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.string(from: date)
    }
    
    
}
