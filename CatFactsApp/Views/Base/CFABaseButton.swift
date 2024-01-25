//
//  CFABaseButton.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 11.12.23.
//

import UIKit
import SnapKit

class CFABaseButton: UIButton {
    private let label = UILabel()
    
    func configure(withTitle title: String) {
        label.text = title
        
        configureAppearance()
        addSubviews()
        constraintViews()
        
        self.addTarget(self, action: #selector(touchDownAnimation), for: [
            .touchDown,
            .touchDragInside
        ])
        self.addTarget(self, action: #selector(touchUpAnimation), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
    
    @objc func touchDownAnimation() {
        UIView.animate(withDuration: 0.5, animations: { self.alpha = 0.55 })
    }
    
    @objc func touchUpAnimation() {
        UIView.animate(withDuration: 0.5, animations: { self.alpha = 1 })
    }
}

extension CFABaseButton {
    func configureAppearance() {
        
        backgroundColor = Resources.Colors.element
        layer.borderColor = Resources.Colors.separator.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = Resources.designValue
        
        label.textAlignment = .center
    }
    
    func addSubviews() {
        
        setupSubviews(label)
    }
    
    func constraintViews() {
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(Resources.designValue)
            make.top.equalTo(snp.top)
            make.trailing.equalTo(snp.trailing).offset(-Resources.designValue)
            make.bottom.equalTo(snp.bottom)
        }
    }}
