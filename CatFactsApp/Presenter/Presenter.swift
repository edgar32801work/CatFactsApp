//
//  Presenter.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 8.12.23.
//

import Foundation
import UIKit
import CoreData

final class Presenter {

    
}

extension Presenter: FactsViewPresentationDelegate {
    
    // MARK: - RANDOM FACTS
        
    func getRandomFactsCount() -> Int {
        MTUserDefaults.shared.proposedFactsAmount
    }
    
    func getRandomFact(forRow i: Int) async -> (String?, UIImage?) {
        if ModelManager.shared.proposedFacts.count <= i {
            let fact: Fact? = await ModelManager.shared.getFactFromURL(appendArr: true)
            let text = fact?.factJSON?.fact
            let image = fact?.image
            return (text, image)
        } else {
            let fact: Fact? = ModelManager.shared.proposedFacts[i]
            let text = fact?.factJSON?.fact
            let image = fact?.image
            return (text, image)
        }
    }
    
    func updateRandomFact(forRow i: Int) async -> (String?, UIImage?) {
        let fact = await ModelManager.shared.getFactFromURL(appendArr: false)
        if let fact = fact {
            ModelManager.shared.proposedFacts[i] = fact
        }
        let text = fact?.factJSON?.fact
        let image = fact?.image
        return (text, image)
    }
    
    func updateAllRandomFacts() {
        ModelManager.shared.proposedFacts.removeAll()
    }
    
    // MARK: - USER FACTS
    
    func getUserFactsCount() -> Int {
        ModelManager.shared.userFacts.count
    }
    
    func getUserFact(forRow i: Int) -> (String?, UIImage?) {
        let fact = ModelManager.shared.userFacts[i]
        let text = fact.text
        let image = fact.getImage()
        return (text, image)
    }
    
    func updateUserFact(atRow i: Int, withText text: String?, image: UIImage?) {
        ModelManager.shared.updateFact(id: i, text: text, image: image)
    }
    
    // MARK: - SAVED FACTS
    
    func getSavedFactsCount() -> Int {
        ModelManager.shared.savedFacts.count
    }

    func getSavedFact(forRow i: Int) -> (String?, UIImage?) {
        let fact = ModelManager.shared.savedFacts[i]
        let text = fact.text
        let image = fact.getImage()
        return (text, image)
        
    }
    
    // MARK: - ADDICTION & REMOVING
    
    func saveFact(to factsType: FactsViewController.FactsTableSection?, withText text: String?, image: UIImage?) {
        switch factsType {
        case .userFacts:
            ModelManager.shared.createFact(factType: .userFact, text: text, image: image)
        case .savedFacts:
            ModelManager.shared.createFact(factType: .savedFact, text: text, image: image)
        default: return
        }
    }
    
    func removeFact(from factsType: FactsViewController.FactsTableSection?, atRow i: Int) {
        switch factsType {
        case .userFacts:
            ModelManager.shared.deleteFact(factType: .userFact, id: i)
        case .savedFacts:
            ModelManager.shared.deleteFact(factType: .savedFact, id: i)
        default: return
        }
    }
}

extension Presenter: SettingsViewPresentationDelegate {
    
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
