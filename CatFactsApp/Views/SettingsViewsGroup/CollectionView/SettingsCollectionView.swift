//
//  SettingsCollectionView.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 27.12.23.
//

import UIKit

final class SettingsCollectionView: UICollectionView {
     
    let layout: UICollectionViewFlowLayout
    
    init() {
        layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        configureAppearance()
        addSubviews()
        constraintViews()
    }

    required init?(coder: NSCoder) {
        layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        configureAppearance()
        addSubviews()
        constraintViews()
    }
}

extension SettingsCollectionView {
    func configureAppearance() {
        contentInset = UIEdgeInsets(top: Resources.designValue, left: 0, bottom: 0, right: 0)
        backgroundColor = Resources.Colors.background
        layout.minimumLineSpacing = 4
    }
    
    func addSubviews() {}
    
    func constraintViews() {}
}


