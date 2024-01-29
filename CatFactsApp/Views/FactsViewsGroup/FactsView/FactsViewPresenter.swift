//
//  FactsViewPresenter.swift
//  CatFactsApp
//
//  Created by Эдгар Кусков on 29.01.24.
//

import Foundation
import CoreData
import UIKit

final class FactsViewPresenter: FactsViewPresenterProtocol {
    
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
            return MTUserDefaults.shared.proposedFactsAmount
        
        case .favouritsFacts:
            switch FactsTableSection(rawValue: section) {
            
            case .userFacts:
                return CoreDataManager.shared.userFacts.count
                
            case .savedFacts:
                return CoreDataManager.shared.savedFacts.count
            
            default:
                return 0
            }
        }
    }
    
    func prepareCell(_ cell: FactsTableViewCell, tableType: FactsTableType, indexPath: IndexPath) {
        
        switch tableType {
            
        case .proposedFacts:
            if NetDataManager.shared.areProposedFactsReady {
                let fact = NetDataManager.shared.getProposedFact(at: indexPath.row)
                cell.configure(withTitle: fact?.factJSON?.fact)
            } else {
                NetDataManager.shared.reserveOnePosInArr()
                updateAndPrepareCell(cell, indexPath: indexPath)
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
    
    func prepareVC(_ vc: SingleFactShowingViewController, tableType: FactsTableType, indexPath: IndexPath) {
        switch tableType {
        case .proposedFacts:
            if NetDataManager.shared.areProposedFactsReady {
                let fact = NetDataManager.shared.getProposedFact(at: indexPath.row)
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
    
    func saveProposedFact(atRow index: Int) {
        if NetDataManager.shared.areProposedFactsReady {
            let fact = NetDataManager.shared.getProposedFact(at: index)
            saveFact(to: .savedFacts, withText: fact?.factJSON?.fact, image: fact?.image)
        }
    }
    
    func updateAndPrepareCell(_ cell: FactsTableViewCell, indexPath: IndexPath) {
        Task {
            guard let fact = await NetDataManager.shared.getFactFromURL() else { return }
            Task { @MainActor in
                cell.configure(withTitle: fact.factJSON?.fact)
                NetDataManager.shared.insertFact(fact, at: indexPath.row)
            }
        }
    }
    
    func updateAllRandomFacts() {
        NetDataManager.shared.removeAllFacts()
    }
    
    func getUserFactsCount() -> Int {
        CoreDataManager.shared.userFacts.count
    }
    
    func getUserFact(forRow i: Int) -> (String?, UIImage?) {
        let fact = CoreDataManager.shared.userFacts[i]
        let text = fact.text
        let image = fact.getImage()
        return (text, image)
    }
    
    func updateUserFact(atRow i: Int, withText text: String?, image: UIImage?) {
        CoreDataManager.shared.updateFact(id: i, text: text, image: image)
    }
    
    func getSavedFactsCount() -> Int {
        CoreDataManager.shared.savedFacts.count
    }

    func getSavedFact(forRow i: Int) -> (String?, UIImage?) {
        let fact = CoreDataManager.shared.savedFacts[i]
        let text = fact.text
        let image = fact.getImage()
        return (text, image)
        
    }
    
    func saveFact(to factsType: FactsTableSection?, withText text: String?, image: UIImage?) {
        switch factsType {
        case .userFacts:
            CoreDataManager.shared.createFact(factType: .userFact, text: text, image: image)
        case .savedFacts:
            CoreDataManager.shared.createFact(factType: .savedFact, text: text, image: image)
        default: return
        }
    }
    
    func removeFact(from factsType: FactsTableSection?, atRow i: Int) {
        switch factsType {
        case .userFacts:
            CoreDataManager.shared.deleteFact(factType: .userFact, id: i)
        case .savedFacts:
            CoreDataManager.shared.deleteFact(factType: .savedFact, id: i)
        default: return
        }
    }
}
