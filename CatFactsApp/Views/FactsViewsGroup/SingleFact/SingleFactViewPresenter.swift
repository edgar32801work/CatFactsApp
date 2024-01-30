//
//  SingleFactPresenter.swift
//  CatFactsApp
//
//  Created by Эдгар Кусков on 29.01.24.
//

import Foundation
import UIKit

final class SingleFactViewPresenter: SingleFactViewPresenterProtocol {
    
    func saveFact(to factsType: FactsViewPresenter.FactsTableSection?, withText text: String?, image: UIImage?) {
        switch factsType {
        case .userFacts:
            CoreDataManager.shared.createFact(factType: .userFact, text: text, image: image)
        case .savedFacts:
            CoreDataManager.shared.createFact(factType: .savedFact, text: text, image: image)
        default: return
        }
    }
    
    func updateUserFact(atRow i: Int, withText text: String?, image: UIImage?) {
        CoreDataManager.shared.updateFact(id: i, text: text, image: image)
    }
    
}
