//
//  EmtyListView.swift
//  TaskLisk
//
//  Created by Davit on 02.02.22.
//

import Foundation
import UIKit

class EmptyListView: UIView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

extension EmptyListView {
    func style() {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        imageView.image = UIImage(systemName: "list.bullet.indent", withConfiguration: configuration)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5
    }
    
    func layout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
        
}
