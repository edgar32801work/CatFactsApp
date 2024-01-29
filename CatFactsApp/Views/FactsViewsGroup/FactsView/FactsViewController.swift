//
//  FactsViewController.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import UIKit
import SnapKit

protocol FactsViewPresenterProtocol: AnyObject {
    
    func getSectionTitleFor(_ tableType: FactsViewPresenter.FactsTableType, section: Int) -> String
    func getNumberOfRowsIn(section: Int, forTableType: FactsViewPresenter.FactsTableType) -> Int
    func prepareCell(_ cell: FactsTableViewCell, tableType: FactsViewPresenter.FactsTableType, indexPath: IndexPath)
    func prepareVC(_ vc: SingleFactShowingViewController, tableType: FactsViewPresenter.FactsTableType, indexPath: IndexPath)
    func updateAndPrepareCell(_ cell: FactsTableViewCell, indexPath: IndexPath)
    func saveProposedFact(atRow: Int)
    func updateAllRandomFacts()
    
    func getUserFact(forRow i: Int) -> (String?, UIImage?)
  
    func getSavedFact(forRow i: Int) -> (String?, UIImage?)

    func removeFact(from factsType: FactsViewPresenter.FactsTableSection?, atRow i: Int)
}

final class FactsViewController: CFABaseController {
    
    // MARK: - LOCAL PROPERTIES
        
    private var currentFactsTableType: FactsViewPresenter.FactsTableType = .proposedFacts
    private var dataDelegate: FactsViewPresenter?
    private let segmentedControl = UISegmentedControl()
    private let tableView = UITableView()
    private var swipeDirection: UISwipeGestureRecognizer.Direction {
        switch currentFactsTableType {
        case .proposedFacts:
            return .left
        case .favouritsFacts:
            return .right
        }
    }
    
    // MARK: - LOCAL METHODS
    
    func addNavBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSingleFactAddictionScreen))
    }
    
    @objc func showSingleFactAddictionScreen() {
        let destinationVC = SingleFactEditingViewController()
        destinationVC.configure(vcForUpdating: self, image: Resources.Images.imageErr)
        navigationController?.showDetailViewController(destinationVC, sender: self)
    }
    
    @objc func changeFactsTableType() {
        currentFactsTableType.switchValue()
        segmentedControl.selectedSegmentIndex = currentFactsTableType.rawValue
        updateFactsTable()
        if let gesture = self.view.gestureRecognizers?.first as? UISwipeGestureRecognizer {
            gesture.direction = swipeDirection
        }
    }
 
    @objc func updateFactsTable() {
        tableView.reloadData()
    }
    
    @objc func handleRefreshControl() {
        if currentFactsTableType == .proposedFacts {
            dataDelegate?.updateAllRandomFacts()
            updateFactsTable()
        }
        DispatchQueue.main.async {
              self.tableView.refreshControl?.endRefreshing()
           }
    }
    
    func getRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return refreshControl
    }
    
    func addScreenSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeFactsTableType))
        swipeGesture.direction = swipeDirection
        self.view.addGestureRecognizer(swipeGesture)
    }

// MARK: - CONFIGURATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDelegate = FactsViewPresenter()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FactsTableViewCell.self, forCellReuseIdentifier: FactsTableViewCell.id)
        tableView.refreshControl = getRefreshControl()
        
        addScreenSwipeGesture()
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeFactsTableType), for: .valueChanged)
    }
}

// MARK: - APPEARANCE

extension FactsViewController {
    override func configureAppearance() {
        super.configureAppearance()
        
        title = Resources.Strings.factsTitle
        
        addNavBarButton()
        navigationItem.rightBarButtonItem?.tintColor = Resources.Colors.tintColor
        
        tableView.backgroundColor = Resources.Colors.background
        
        segmentedControl.insertSegment(withTitle: Resources.Strings.Facts.SegmentedControl.proposedFacts, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: Resources.Strings.Facts.SegmentedControl.favouritsFacts, at: 1, animated: true)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.setupSubviews(segmentedControl)
        view.setupSubviews(tableView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(8)
            make.leading.equalTo(view.snp.leading).offset(Resources.designValue)
            make.trailing.equalTo(view.snp.trailing).offset(-Resources.designValue)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(4)
            make.trailing.equalTo(view.snp.trailing).offset(-4)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

}

// MARK: - SECTIONS & CELLS CONFIGURATION

extension FactsViewController: UITableViewDataSource {
    
    // NUMBER OF SECTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentFactsTableType {
        case .proposedFacts:
            return 1
        case .favouritsFacts:
            return 2
        }
    }
    
    // SECTION TITLE
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataDelegate?.getSectionTitleFor(currentFactsTableType, section: section)
    }
    
    // NUMBER OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDelegate?.getNumberOfRowsIn(section: section, forTableType: currentFactsTableType) ?? 0        
    }
    
    // CELL FOR ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FactsTableViewCell.id, for: indexPath) as? FactsTableViewCell else { return UITableViewCell() }
        //cell.separatorInset = .init(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)            // TODO: разобраться поддробнее
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.configureLoading()
        dataDelegate?.prepareCell(cell, tableType: currentFactsTableType, indexPath: indexPath)
        
        return cell
    }
}

// MARK: - CELL INTERACTION
extension FactsViewController: UITableViewDelegate {
    
    // DID SELECT ROW AT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = SingleFactShowingViewController()
        navigationController?.showDetailViewController(destinationVC, sender: self)
        dataDelegate?.prepareVC(destinationVC, tableType: currentFactsTableType, indexPath: indexPath)
    }
    
    // TRAILING SWIPE
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        switch currentFactsTableType {
        
        case .proposedFacts:
            let uploadedAction = UIContextualAction(style: .normal, title: "") { [weak self] action, sourceView, completionHandler in
                if let cell = tableView.cellForRow(at: indexPath) as? FactsTableViewCell {
                    cell.configureLoading()
                    if let self {
                        dataDelegate?.updateAndPrepareCell(cell, indexPath: indexPath)
                    }
                }
                completionHandler(true)
            }
            uploadedAction.backgroundColor = Resources.Colors.Facts.CellSwipes.proposedTrailing
            uploadedAction.title = Resources.Strings.Facts.CellSwipes.proposedTrailing
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
            return swipeConfiguration
        
        case .favouritsFacts:
            let uploadedAction = UIContextualAction(style: .normal, title: "") { [weak self] action, sourceView, completionHandler in
                
                let alert = UIAlertController(title: Resources.Strings.Facts.DeletingAlert.title,
                                              message: Resources.Strings.Facts.DeletingAlert.message,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: Resources.Strings.Facts.DeletingAlert.deleteAction,
                                              style: .destructive,
                                              handler: { [weak self] _ in
                    let section = FactsViewPresenter.FactsTableSection(rawValue: indexPath.section)
                    self?.dataDelegate?.removeFact(from: section, atRow: indexPath.row)
                    self?.updateFactsTable()
                }))
                
                alert.addAction(UIAlertAction(title: Resources.Strings.Facts.DeletingAlert.cancelAction,
                                              style: .default,
                                              handler: nil))
                
                self?.present(alert, animated: true, completion: nil)

                completionHandler(true)
            }
            uploadedAction.backgroundColor = Resources.Colors.Facts.CellSwipes.favouritsTrailing
            uploadedAction.title = Resources.Strings.Facts.CellSwipes.favouritsTrailing
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
            return swipeConfiguration
        }
    }
    
    // LEADING SWIPE
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch currentFactsTableType {
            
        case .proposedFacts:
            let uploadedAction = UIContextualAction(style: .normal, title: "") { [weak self] action, sourceView, completionHandler in
                if let self {
                    self.dataDelegate?.saveProposedFact(atRow: indexPath.row)
                }
                completionHandler(true)
            }
            uploadedAction.backgroundColor = Resources.Colors.Facts.CellSwipes.proposedLeading
            uploadedAction.title = Resources.Strings.Facts.CellSwipes.proposedLeading
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
            return swipeConfiguration
            
        case .favouritsFacts:
            switch FactsViewPresenter.FactsTableSection(rawValue: indexPath.section) {
                
            case .userFacts:
                let uploadedAction = UIContextualAction(style: .normal, title: "") { action, sourceView, completionHandler in
                    let fact: (text: String?, image: UIImage?)? = self.dataDelegate?.getUserFact(forRow: indexPath.row)
                    let destinationVC = SingleFactEditingViewController()
                    destinationVC.configure(vcForUpdating: self, image: fact?.image, id: indexPath.row, text: fact?.text)
                    self.navigationController?.showDetailViewController(destinationVC, sender: self)
                    completionHandler(true)
                }
                uploadedAction.backgroundColor = Resources.Colors.Facts.CellSwipes.favouritsLeading
                uploadedAction.title = Resources.Strings.Facts.CellSwipes.favouritsLeading
                let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
                return swipeConfiguration
                
            default:
                return UISwipeActionsConfiguration()
            }
        }
    }
}

