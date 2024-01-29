//
//  FactsTableViewCell.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 8.12.23.
//

// TODO: Добавить стрелочки перехода по ячейке

import UIKit
import SnapKit

final class FactsTableViewCell: UITableViewCell {
    
    static let id = "FactsTableViewCell"
    
    private let label = UILabel()
    private let image = UIImageView()
    
    func configureLoading() {
        configure(withTitle: "LOADING...")
    }
    
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
        backgroundColor = Resources.Colors.element
        
        label.numberOfLines = 1
        
        image.image = UIImage(systemName: "chevron.right")
        image.tintColor = Resources.Colors.tintColor
    }
    
    func addSubviews() {
        setupSubviews(label)
        setupSubviews(image)
    }
    
    func constraintViews() {
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(snp.leading).offset(Resources.designValue)
            make.width.equalTo(snp.width).multipliedBy(0.7)
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-Resources.designValue)
        }
    }
}
