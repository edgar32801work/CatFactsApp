//
//  MTUserDefaults.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 28.12.23.
//

import Foundation
import UIKit

struct MTUserDefaults {
    
    enum SettingsCases: Int, CaseIterable {
        
        case proposedFactsAmount, appTheme, language
    }
     
    enum Theme: Int {
        case light, dark, device
        
        func getUserInterfaceStyle() -> UIUserInterfaceStyle {
            switch self {
                
            case .light:
                return .light
            case .dark:
                return .dark
            case .device:
                return .unspecified
            }
        }
        
        mutating func switchValue() {
            switch self {
            case .light:
                self = .dark
            case .dark:
                self = .device
            case .device:
                self = .light
            }
        }
    }
    
    static var shared = MTUserDefaults()
    private init() {}
    
    private let themeKey = "selectedTheme"
    private let proposedFactsAmountKey = "proposedFactsAmount"
    
    var proposedFactsAmount: Int {
        get { UserDefaults.standard.integer(forKey: proposedFactsAmountKey) }
        set { UserDefaults.standard.set(newValue, forKey: proposedFactsAmountKey) }
    }
    
    var theme: Theme {
        get { Theme(rawValue: UserDefaults.standard.integer(forKey: themeKey)) ?? .device }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: themeKey) }
    }
    
}
