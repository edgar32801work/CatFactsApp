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
        Resources.Settings.proposedFactsAmount
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
    
    // MARK: - USER FACTS
    
    func getUserFactsCount() -> Int {
        ModelManager.shared.userFacts.count
    }
    
    func getUserFact(forRow i: Int) -> (String?, UIImage?) {
        let fact = ModelManager.shared.userFacts[i]
        let text = fact.text
        if let image = fact.image {
            return (text, UIImage(data: image))
        }
        return (text, Resources.Images.imageErr)
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
        if let image = fact.image {
            return (text, UIImage(data: image))
        }
        return (text, Resources.Images.imageErr)
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
