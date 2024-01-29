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
    func updateAndPrepareCell(_ cell: FactsTableViewCell, indexPath: IndexPath) {

        Task {
            let fact: (title: String?, _: UIImage?)? = await updateRandomFact(forRow: indexPath.row)
            Task { @MainActor in
                cell.configure(withTitle: fact?.title)
            }
        }  
    }
    
    func prepareVC(_ vc: SingleFactShowingViewController, tableType: FactsTableType, indexPath: IndexPath) {
        switch tableType {
        case .proposedFacts:
            if ModelManager.shared.areProposedFactsReady {
                let fact = ModelManager.shared.getProposedFact(at: indexPath.row)
                vc.configure(withText: fact?.factJSON?.fact, image: fact?.image)
            } else {
                debugPrint("SingleFactVC preparation error: amount of facts in var proposedFacts isn't correct")
                vc.configureError()
            }
        case .favouritsFacts:
            switch FactsTableSection(rawValue: indexPath.section) {
            case .userFacts:
                let fact: (text: String?, image: UIImage?)? = getUserFact(forRow: indexPath.row)
                vc.configure(withText: fact?.text, image: fact?.image)
            case .savedFacts:
                let fact: (text: String?, image: UIImage?)? = getSavedFact(forRow: indexPath.row)
                vc.configure(withText: fact?.text, image: fact?.image)
            default:
                debugPrint("SingleFactVC preparation error: FactsTableSection get unexpectable rawValue")
                vc.configureError()
            }
        }
    }
    
    
    enum FactsTableType: Int {
        case proposedFacts, favouritsFacts
        
        mutating func switchValue() {
            switch self {
            case .proposedFacts:
                self = .favouritsFacts
            case .favouritsFacts:
                self = .proposedFacts
            }
        }
    }
    
    enum FactsTableSection: Int {
        case userFacts, savedFacts
    }
    
    func getSectionTitleFor(_ tableType: FactsTableType, section: Int) -> String {
        switch tableType {
        case .proposedFacts:
            return Resources.Strings.Facts.Sections.proposedFacts
        case .favouritsFacts:
            switch FactsTableSection(rawValue: section) {
                
            case .userFacts: 
                return Resources.Strings.Facts.Sections.userFacts
                
            case .savedFacts: 
                return Resources.Strings.Facts.Sections.savedFacts
                
            default: 
                return Resources.Strings.Facts.Sections.unknownSection
            }
        }
    }
    
    func getNumberOfRowsIn(section: Int, forTableType tableType: FactsTableType) -> Int {
        
        switch tableType {
            
        case .proposedFacts:
            return getRandomFactsCount()
        
        case .favouritsFacts:
            switch FactsTableSection(rawValue: section) {
            
            case .userFacts:
                return getUserFactsCount()
            
            case .savedFacts:
                return getSavedFactsCount()
            
            default:
                return 0
            }
        }
    }

    func prepareCell(_ cell: FactsTableViewCell, tableType: FactsTableType, indexPath: IndexPath) {
        
        switch tableType {
            
        case .proposedFacts:
            if ModelManager.shared.areProposedFactsReady {
                let fact = ModelManager.shared.getProposedFact(at: indexPath.row)
                cell.configure(withTitle: fact?.factJSON?.fact)
            } else {
                ModelManager.shared.reserveOnePosInArr()
                Task {
                    guard let fact = await ModelManager.shared.getFactFromURL(appendArr: true) else { return }
                    Task { @MainActor in
                        cell.configure(withTitle: fact.factJSON?.fact)
                        ModelManager.shared.insertFact(fact, at: indexPath.row)
                    }
                }
            }
            
        case .favouritsFacts:
            guard let section = FactsTableSection(rawValue: indexPath.section) else { return }
            switch section {
            case .userFacts:
                let fact: (title: String?, _: UIImage?)? = getUserFact(forRow: indexPath.row)
                cell.configure(withTitle: fact?.title)
            case .savedFacts:
                let fact: (title: String?, _: UIImage?)? = getSavedFact(forRow: indexPath.row)
                cell.configure(withTitle: fact?.title)
            }
        }
    }
    
    func saveProposedFact(atRow index: Int) {
        if ModelManager.shared.areProposedFactsReady {
            let fact = ModelManager.shared.getProposedFact(at: index)
            saveFact(to: .savedFacts, withText: fact?.factJSON?.fact, image: fact?.image)
        }
    }
    
    
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
    
    func saveFact(to factsType: FactsTableSection?, withText text: String?, image: UIImage?) {
        switch factsType {
        case .userFacts:
            ModelManager.shared.createFact(factType: .userFact, text: text, image: image)
        case .savedFacts:
            ModelManager.shared.createFact(factType: .savedFact, text: text, image: image)
        default: return
        }
    }
    
    func removeFact(from factsType: FactsTableSection?, atRow i: Int) {
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
