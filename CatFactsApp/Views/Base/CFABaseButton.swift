//
//  CFABaseButton.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 11.12.23.
//

import UIKit

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
        layer.cornerRadius = Resources.designValue
        
        label.textAlignment = .center
    }
    
    func addSubviews() {
        
        setupSubview(label)
    }
    
    func constraintViews() {
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.designValue),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.designValue),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
