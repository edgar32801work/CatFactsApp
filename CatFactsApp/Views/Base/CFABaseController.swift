//
//  CFABaseController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 8.12.23.
//

import UIKit

class CFABaseController: UIViewController {    
    override func viewDidLoad() {
        configureAppearance()
        addSubviews()
        constraintViews()
    }
}


@objc extension CFABaseController {
    func configureAppearance() {
        view.backgroundColor = Resources.Colors.background
    }
    
    func addSubviews() { }
    
    func constraintViews() { }
}
