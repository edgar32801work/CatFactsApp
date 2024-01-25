//
//  SingleFactShowingViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 10.12.23.
//

import UIKit

final class SingleFactShowingViewController: CFABaseController {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let labelBackgroundView = UIView()
    private let label = UILabel()
    private let closeButton = CFABaseButton()

    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - CONFIGURATION

    func configure(withText text: String?,
                   image: UIImage? = Resources.Images.imageErr) {
        label.text = text
        imageView.image = image
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: closeButton.frame.maxY + 40)
    }
}

// MARK: - APPEARANCE

extension SingleFactShowingViewController {
    override func configureAppearance() {
        super.configureAppearance()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        labelBackgroundView.backgroundColor = Resources.Colors.element
        labelBackgroundView.layer.borderColor = Resources.Colors.separator.cgColor
        labelBackgroundView.layer.borderWidth = 0.5
        labelBackgroundView.layer.cornerRadius = Resources.designValue
        labelBackgroundView.clipsToBounds = true
        label.numberOfLines = 0
        
        imageView.contentMode = .scaleAspectFit
        
        closeButton.configure(withTitle: Resources.Strings.Facts.Buttons.closeButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        labelBackgroundView.setupSubview(label)
        
        view.setupSubview(scrollView)
        
        scrollView.setupSubview(imageView)
        scrollView.setupSubview(labelBackgroundView)
        scrollView.setupSubview(closeButton)
    }
    
    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            labelBackgroundView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            labelBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            labelBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            
            label.trailingAnchor.constraint(equalTo: labelBackgroundView.trailingAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: labelBackgroundView.topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: labelBackgroundView.leadingAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: labelBackgroundView.bottomAnchor, constant: -6),

            closeButton.topAnchor.constraint(equalTo: labelBackgroundView.bottomAnchor, constant: 60),
            closeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
        ])
    }
}
