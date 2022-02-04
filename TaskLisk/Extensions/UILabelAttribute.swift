//
//  UILabelAttribute.swift
//  TaskLisk
//
//  Created by Davit on 27.01.22.
//

import UIKit

extension UILabel {
    func makeStrikeThrough(_ string: String) {
        let strikeThroughAttribute = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let strikeThrough = NSAttributedString(string: string, attributes: strikeThroughAttribute)
        
        attributedText = strikeThrough
    }
}
