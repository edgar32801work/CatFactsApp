//
//  SettingsCollectionViewCell.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 27.12.23.
//

import UIKit

final class SettingsCollectionViewCell: UICollectionViewCell {
    
    static let id = "SettingsCollectionViewCell"
    
    weak var rootVC: SettingsViewController?
    
    let title = UILabel()
    let proposedFactsAmountTF = UITextField()
    let appThemeButton = CFABaseButton()
    let languagePicker = UIPickerView()
    
    
    func configure(as cellType: Presenter.SettingsCases, rootVC: SettingsViewController) {
        
        self.rootVC = rootVC
        
        switch cellType {
        case .proposedFactsAmount:
            configureAppearance(withTitleText: Resources.Strings.Settings.proposedFactsAmount)
            addSubviews(withSecondView: proposedFactsAmountTF)
            constraintViews(withSecondView: proposedFactsAmountTF)
            
            if let proposedFactsAmount = rootVC.dataDelegate?.currentProposedFactsAmount {
                proposedFactsAmountTF.text = String(proposedFactsAmount)
            }
            proposedFactsAmountTF.delegate = self
        
        case .appTheme:
            configureAppearance(withTitleText: Resources.Strings.Settings.appTheme)
            addSubviews(withSecondView: appThemeButton)
            constraintViews(withSecondView: appThemeButton)
            
            if let buttonTitle = rootVC.dataDelegate?.currentThemeTitle {
                appThemeButton.configure(withTitle: buttonTitle)
            }
            appThemeButton.addTarget(self, action: #selector(appThemeButtonAction), for: .touchUpInside)
        
        case .language:
            configureAppearance(withTitleText: Resources.Strings.Settings.language)
            addSubviews(withSecondView: languagePicker)
            constraintViews(withSecondView: languagePicker)
            
            languagePicker.backgroundColor = .brown
        }
    }
    
    @objc func appThemeButtonAction() {
        rootVC?.dataDelegate?.switchTheme(windowForUpdating: window)
        if let buttonTitle = rootVC?.dataDelegate?.currentThemeTitle {
            appThemeButton.configure(withTitle: buttonTitle)
        }
    }
}

extension SettingsCollectionViewCell {
    func configureAppearance(withTitleText titleText: String) {
        
        proposedFactsAmountTF.borderStyle = .roundedRect
        proposedFactsAmountTF.layer.borderColor = Resources.Colors.separator.cgColor
        proposedFactsAmountTF.backgroundColor = Resources.Colors.element
        
        title.text = titleText
        
        backgroundColor = Resources.Colors.element
        
        addSeparator(x: 0, y: 0, width: bounds.width, height: 0.5)
        addSeparator(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
    }
    
    func addSubviews(withSecondView secondView: UIView) {

        setupSubview(title)
        setupSubview(secondView)
    }
    
    func constraintViews(withSecondView secondView: UIView) {
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.designValue),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            secondView.leadingAnchor.constraint(equalTo: title.trailingAnchor),
            secondView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.designValue),
            secondView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            secondView.heightAnchor.constraint(equalTo: title.heightAnchor, multiplier: 0.9)
        ])
    }
}

extension SettingsCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {          // TODO: - заприватить все делегаты
        if let text = textField.text, let value = Int(text) {
            rootVC?.dataDelegate?.updateProposedFactsAmount(withNewValue: value)
            return true
            
        } else {
            let alertVC = UIAlertController(title: Resources.Strings.Settings.TextFieldAlert.title,
                                            message: Resources.Strings.Settings.TextFieldAlert.message,
                                            preferredStyle: .actionSheet)
            
            alertVC.addAction(UIAlertAction(title: Resources.Strings.Settings.TextFieldAlert.action,
                                            style: .default,
                                            handler: nil))
            
            rootVC?.present(alertVC, animated: true)
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
    }
}


