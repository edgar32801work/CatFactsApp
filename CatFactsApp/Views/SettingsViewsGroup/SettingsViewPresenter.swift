//
//  SettingsViewPresenter.swift
//  CatFactsApp
//
//  Created by Эдгар Кусков on 29.01.24.
//

import Foundation
import UIKit

final class SettingsViewPresenter: SettingsViewPresenterProtocol {
    
    var currentProposedFactsAmount: Int {
        MTUserDefaults.shared.proposedFactsAmount
    }
    
    func updateProposedFactsAmount(withNewValue newValue: Int) {
        MTUserDefaults.shared.proposedFactsAmount = newValue
    }
    
    var currentThemeTitle: String {
        
        switch MTUserDefaults.shared.theme {
        case .light:
            return Resources.Strings.Settings.ThemeCases.light
            
        case .dark:
            return Resources.Strings.Settings.ThemeCases.dark
            
        case .device:
            return Resources.Strings.Settings.ThemeCases.device
        }
    }
    
    func switchTheme(windowForUpdating: UIWindow?) {
        MTUserDefaults.shared.theme.switchValue()
        windowForUpdating?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterfaceStyle()
    }
}
