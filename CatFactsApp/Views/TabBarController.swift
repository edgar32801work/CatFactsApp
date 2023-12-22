//
//  ViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 6.12.23.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let factsViewController = NavBarController(rootViewController: FactsViewController())
    private let settingsViewController = NavBarController(rootViewController: SettingsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureAppearance()
    }
}

extension TabBarController {
    func configureAppearance() {
        
        tabBar.addSeparator(x: 0, y: 0, width: view.bounds.width, height: 0.5)
        tabBar.backgroundColor = Resources.Colors.Bars.background
        
        factsViewController.tabBarItem = UITabBarItem(title: Resources.Strings.factsTitle,
                                                      image: Resources.Images.TabBar.factsIcon,
                                                      tag: 0)
        settingsViewController.tabBarItem = UITabBarItem(title: Resources.Strings.settingsTitle,
                                                         image: Resources.Images.TabBar.settingsIcon,
                                                         tag: 1)
        setViewControllers([factsViewController, settingsViewController], animated: true)
        
    }
}

