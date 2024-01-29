//
//  NetDataManager.swift
//  CatFactsApp
//
//  Created by Эдгар Кусков on 29.01.24.
//

import Foundation

final class NetDataManager {
    
    static let shared = NetDataManager()
    private init() {}
    
    private var proposedFacts: [Fact?] = []
    
    var areProposedFactsReady: Bool {
        proposedFacts.count == MTUserDefaults.shared.proposedFactsAmount
    }
    
    func reserveOnePosInArr() {
        proposedFacts.append(Fact())
    }
    
    func getProposedFact(at index: Int) -> Fact? {
        return proposedFacts[index]
    }
    
    func insertFact(_ fact: Fact, at index: Int) {
        proposedFacts[index] = fact
    }
    
    func removeAllFacts() {
        proposedFacts = []
    }
    
    
        
    func getFactFromURL() async -> Fact? {
        do {
            let data = try await NetworkingService.shared.fetchData()
            let decoder = JSONDecoder()
            let factJSON = try decoder.decode(FactJSON.self, from: data)
            let fact = Fact(factJSON: factJSON, image: nil)
            return fact
        } catch {
            debugPrint(error)
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
