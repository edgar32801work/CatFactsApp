//
//  Separator.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import UIKit

final class Separator: UIView {
    
    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.backgroundColor = Resources.Colors.inactive
    }
    
}
