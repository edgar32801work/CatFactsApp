//
//  Fact.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import Foundation
import UIKit

struct FactJSON: Decodable {
    var fact: String        // text
}

struct Fact {
    var factJSON: FactJSON?
    var image: UIImage?
    
    init(factJSON: FactJSON, image: UIImage? = nil) {
        self.factJSON = factJSON
        if let image = image {
            self.image = image
        } else {
            self.image = Resources.Images.imageErr
        }
    }
}
