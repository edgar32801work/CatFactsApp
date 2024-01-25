//
//  SingleFactEditingViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 11.12.23.
//
// TODO: - разобраться подробнее с реализацией смещения клавиатурой

import UIKit
import SnapKit

final class SingleFactEditingViewController: CFABaseController {
    
    private var dataDelegate: FactsViewPresentationDelegate?
    var vcForUpdating: FactsViewController?
    var idForUpdating: Int?
    var addiction: Bool = true
    
    private let scrollView = UIScrollView()
    private let imageButton = UIButton()
    private let textView = UITextView()
    private let saveButton = CFABaseButton()

    @objc func saveAndCloseScreen() {
        let text = textView.text
        let image = imageButton.backgroundImage(for: .normal)
        
        if let id = idForUpdating {
            dataDelegate?.updateUserFact(atRow: id, withText: text, image: image)
        } else {
            dataDelegate?.saveFact(to: .userFacts, withText: text, image: image)
        }
        
        if let vcForUpdating = vcForUpdating {
            vcForUpdating.updateFactsTable()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true) {}
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.imageButton.alpha = 0.6
            self?.imageButton.alpha = 1
        }
    }
    
    @objc func updateViewWithKeyboard(_ notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.minY - 40), animated: true)
    }
    
    @objc func updateViewWithoutKeyboard(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak scrollView] in
            scrollView?.contentInset = .zero
        }
    }
    
    @objc func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    // MARK: - CONFIGURATION
    
    func configure(vcForUpdating: FactsViewController, image: UIImage?, id: Int? = nil, text: String? = nil) {
        self.vcForUpdating = vcForUpdating
        textView.text = text
        idForUpdating = id
        imageButton.setBackgroundImage(image, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDelegate = Builder.shared.buildPresenter()
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.gestureRecognizers = [scrollViewTapGesture]
        
        imageButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        
        textView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewWithKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewWithoutKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
 
    // MARK: - APPEARANCE
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: saveButton.frame.maxY + 40)
    }
    
}

extension SingleFactEditingViewController {
    override func configureAppearance() {
        super.configureAppearance()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        imageButton.layoutIfNeeded()
        imageButton.subviews.first?.contentMode = .scaleAspectFit
        
        textView.backgroundColor = Resources.Colors.element
        textView.layer.borderColor = Resources.Colors.separator.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = Resources.designValue
//        textView.contentInset = UIEdgeInsets(top: 0, left: Resources.designValue, bottom: 0, right: 0)
        textView.clipsToBounds = true
        
        saveButton.configure(withTitle: Resources.Strings.Facts.Buttons.saveButton)
        saveButton.addTarget(self, action: #selector(saveAndCloseScreen), for: .touchUpInside)
        
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.setupSubviews(scrollView)
        scrollView.setupSubviews(imageButton)
        scrollView.setupSubviews(textView)
        scrollView.setupSubviews(saveButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(40)
            make.leading.equalTo(view.snp.leading).offset(17)
            make.trailing.equalTo(view.snp.trailing).offset(-17)
            make.height.equalTo(imageButton.snp.width)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(17)
            make.bottom.equalTo(saveButton.snp.top).offset(-60)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
        }
    }
}

// MARK: - PICKER CONFIGURATION

extension SingleFactEditingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            self?.imageButton.setBackgroundImage(image, for: .normal)
        }
    }
}



