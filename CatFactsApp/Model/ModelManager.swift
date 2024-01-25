//
//  ModelManager.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import Foundation
import CoreData
import UIKit

final class ModelManager {
    
    static let shared = ModelManager(); private init() {}
    
    // MARK: - CORE DATA MANAGEMENT
    
    let savedFactId = "SavedFact"
    let userFactId = "UserFact"
    
    enum FactType {
        case userFact
        case savedFact
    }
    
    var savedFacts: [SavedFact] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: savedFactId)
        return (try? context.fetch(fetchRequest) as? [SavedFact]) ?? []
    }
    
    var userFacts: [UserFact] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: userFactId)
        return (try? context.fetch(fetchRequest) as? [UserFact]) ?? []
    }
    
    lazy private var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate             // TODO: correct optional condition
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription as Any)
        }
    }
    
    func createFact(factType table: FactType, text: String?, image: UIImage? = nil) {
        switch table {
            
        case .savedFact:
            guard let factEntityDescription = NSEntityDescription.entity(forEntityName: savedFactId, in: context) else { return }          // TODO: handle errors
            let fact = UserFact(entity: factEntityDescription, insertInto: context)
            fact.text = text
            fact.saveImage(image)
            
        case .userFact:
            guard let factEntityDescription = NSEntityDescription.entity(forEntityName: userFactId, in: context) else { return }          // TODO: handle errors
            let fact = UserFact(entity: factEntityDescription, insertInto: context)
            fact.text = text
            fact.saveImage(image)
        }
        saveContext()
    }
    
    func updateFact(id: Int, text: String?, image: UIImage? = nil) {
        userFacts[id].text = text
        userFacts[id].saveImage(image)
        saveContext()
    }
    
    func deleteFact(factType table: FactType, id: Int) {
        switch table {
        case .savedFact:
            context.delete(savedFacts[id])
        case .userFact:
            context.delete(userFacts[id])
        }
        saveContext()
    }
    
    
    // MARK: - NETWORK MANAGMENT
    
    var proposedFacts: [Fact] = []
        
    func getFactFromURL(appendArr: Bool) async -> Fact? {
        do {
            let data = try await NetworkingService.shared.fetchData()
            let decoder = JSONDecoder()
            let factJSON = try decoder.decode(FactJSON.self, from: data)
            let fact = Fact(factJSON: factJSON, image: nil)
            if appendArr {
                self.proposedFacts.append(fact)                     // TODO: исправить путающиеся return
            }
            return fact
        } catch {
            debugPrint(error)
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    
}
