//
//  Builder.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 9.12.23.
//

import Foundation

struct Builder {
    
    static let shared = Builder(); private init() { }
    
    func buildPresenter() -> Presenter {
        Presenter()
    }
}
