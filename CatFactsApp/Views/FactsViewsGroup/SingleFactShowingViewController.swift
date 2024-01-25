//
//  SingleFactShowingViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 10.12.23.
//

import UIKit
import SnapKit

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
        
        labelBackgroundView.setupSubviews(label)
        
        view.setupSubviews(scrollView)
        
        scrollView.setupSubviews(imageView)
        scrollView.setupSubviews(labelBackgroundView)
        scrollView.setupSubviews(closeButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(40)
            make.leading.equalTo(view.snp.leading).offset(17)
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(imageView.snp.width)
        }
        
        labelBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(17)
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(labelBackgroundView.snp.bottom).offset(60)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
    }
}
