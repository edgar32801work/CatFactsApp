//
//  SingleFactViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 11.12.23.
//

import UIKit

class SingleFactViewController: CFABaseController {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension SingleFactViewController {
    override func configureAppearance() {
        super.configureAppearance()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        imageView.contentMode = .scaleAspectFit
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.setupSubview(scrollView)
        scrollView.setupSubview(imageView)
    }
    
    override func constraintViews() {
        super.constraintViews()

    }
}
