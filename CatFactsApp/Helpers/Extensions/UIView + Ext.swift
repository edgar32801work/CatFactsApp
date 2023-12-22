//
//  UIView + Ext.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import UIKit

extension UIView {
    func addSeparator(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let separatorView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        separatorView.backgroundColor = Resources.Colors.separator
        self.addSubview(separatorView)
    }
    
    func setupSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
    
    func customCFAAppearance() {
        self.layer.borderWidth = 4
        self.layer.borderColor = Resources.Colors.background.cgColor
        self.layer.cornerRadius = Resources.designValue
        self.clipsToBounds = true
    }
}
