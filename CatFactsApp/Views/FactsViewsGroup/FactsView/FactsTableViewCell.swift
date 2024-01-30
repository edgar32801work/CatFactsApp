//
//  FactsTableViewCell.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 8.12.23.
//

// TODO: Добавить стрелочки перехода по ячейке

import UIKit
import SnapKit

protocol FactsTableViewCellPresenterProtocol {
    
}

final class FactsTableViewCell: UITableViewCell {
    
    static let id = "FactsTableViewCell"
    
    private let label = UILabel()
    private let image = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    
    func configure(withTitle title: String? = nil, state: FactsTableViewCellPresenter.CellLoadingType = .normal) {
        
        configureAppearance()
        addSubviews(forState: state)
        constraintViews(forState: state)
        
        switch state {
            
        case .normal:
            activityIndicator.stopAnimating()	
        case .loading:
            activityIndicator.startAnimating()
        }
        
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
    
    func addSubviews(forState state: FactsTableViewCellPresenter.CellLoadingType) {
        switch state {
            
        case .normal:
            setupSubviews(label)
            setupSubviews(image)
        case .loading:
            setupSubviews(activityIndicator)
        }
    }
    
    func constraintViews(forState state: FactsTableViewCellPresenter.CellLoadingType) {
        
        switch state {
            
        case .normal:
            label.snp.makeConstraints { make in
                make.centerY.equalTo(snp.centerY)
                make.leading.equalTo(snp.leading).offset(Resources.designValue)
                make.width.equalTo(snp.width).multipliedBy(0.7)
            }
            
            image.snp.makeConstraints { make in
                make.centerY.equalTo(label.snp.centerY)
                make.trailing.equalTo(snp.trailing).offset(-Resources.designValue)
            }
        case .loading:
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}
