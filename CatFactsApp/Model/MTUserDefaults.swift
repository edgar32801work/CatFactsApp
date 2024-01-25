//
//  MTUserDefaults.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 28.12.23.
//

import Foundation

struct MTUserDefaults {
    
    static var shared = MTUserDefaults()
    private init() {}
    
    private let themeKey = "selectedTheme"
    private let proposedFactsAmountKey = "proposedFactsAmount"
    
    var proposedFactsAmount: Int {
        get { UserDefaults.standard.integer(forKey: proposedFactsAmountKey) }
        set { UserDefaults.standard.set(newValue, forKey: proposedFactsAmountKey) }
    }
    
    var theme: Presenter.Theme {
        get { Presenter.Theme(rawValue: UserDefaults.standard.integer(forKey: themeKey)) ?? .device }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: themeKey) }
    }
    
}
