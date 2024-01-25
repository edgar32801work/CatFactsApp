//
//  SettingsViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import UIKit
import SnapKit

protocol SettingsViewPresentationDelegate {
    var currentProposedFactsAmount: Int { get }
    func updateProposedFactsAmount(withNewValue newValue: Int)
        
    var currentThemeTitle: String { get }
    func switchTheme(windowForUpdating: UIWindow?)
}

final class SettingsViewController: CFABaseController {
    
    private let collectionView = SettingsCollectionView()
    var dataDelegate: SettingsViewPresentationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        configureAppearance()
        addSubviews()
        constraintViews()
        
        dataDelegate = Builder.shared.buildPresenter()
        
        title = Resources.Strings.settingsTitle
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: SettingsCollectionViewCell.id)
    }
}

extension SettingsViewController {
    override func configureAppearance() {
        
    }
    
    override func addSubviews() {
        view.setupSubviews(collectionView)
    }
    
    override func constraintViews() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension SettingsViewController: UICollectionViewDataSource {
    
    // NUMBER OF ITEMS IN SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Presenter.SettingsCases.allCases.count
    }
    
    // CELL FOR ITEM AT
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCollectionViewCell.id, for: indexPath) as? SettingsCollectionViewCell
        else { return SettingsCollectionViewCell() }              // TODO: - приложение упадет
        
        if let settingCase = Presenter.SettingsCases(rawValue: indexPath.row) {
            cell.configure(as: settingCase, rootVC: self)
        }
        return cell
    }
}


// MARK: - COLLECTION VIEW DELEGATE
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    // SIZE FOR ITEM AT
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
