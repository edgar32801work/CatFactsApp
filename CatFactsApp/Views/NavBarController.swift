//
//  NavBarController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import UIKit

final class NavBarController: UINavigationController {
    override func viewDidLoad() {
        configureAppearance()
    }
}

extension NavBarController {
    func configureAppearance() {
        
        navigationBar.isTranslucent = false
        view.backgroundColor = Resources.Colors.Bars.background
//        navigationBar.prefersLargeTitles = true
        navigationBar.addSeparator(x: 0, y: navigationBar.bounds.height - 0.5, width: view.bounds.width, height: 0.5)
        
    }

}
