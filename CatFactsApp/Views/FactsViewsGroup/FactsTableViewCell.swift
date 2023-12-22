//
//  FactsTableViewCell.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 8.12.23.
//

// TODO: Добавить стрелочки перехода по ячейке

import UIKit

final class FactsTableViewCell: UITableViewCell {
    
    private let label = UILabel()
    private let image = UIImageView()
    func configure(withTitle title: String?) {
        
        configureAppearance()
        addSubviews()
        constraintViews()
        
        label.text = title
        
    }
}

// MARK: - APPEARANCE

extension FactsTableViewCell {
    func configureAppearance() {
        
//        customCFAAppearance()
        
        label.numberOfLines = 1
        
        image.image = UIImage(systemName: "chevron.right")
    }
    
    func addSubviews() {
        setupSubview(label)
        setupSubview(image)
    }
    
    func constraintViews() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.designValue),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            
            image.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.designValue)
        ])
    }
}
