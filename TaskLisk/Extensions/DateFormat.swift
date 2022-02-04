//
//  DateFormat.swift
//  TaskLisk
//
//  Created by Davit on 28.01.22.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
