//
//  ContactViewController.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Model
import FLUtilities

protocol ContactViewControllerProtocol: class {
    var disposable: CompositeDisposable { get }
    var loading: MutableProperty<Bool> { get }
    var sectionModels: MutableProperty<[SectionModel]> { get }
    var sectionCount: Int { get }
    func rowsCount(at section: Int) -> Int
    func cellModel(at indexPath: IndexPath) -> Any
}

class ContactViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel: ContactViewControllerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    deinit {
        self.viewModel.disposable.dispose()
    }

    private func initialSetup() {
        self.viewModel = ContactViewModel(self)
        self.setupTableView()
        
        self.viewModel.disposable += self.viewModel.sectionModels.signal.observeValues { _ in
            DispatchQueue.main.async {            
                self.tableView.reloadData()
            }
        }
        
    }
    
}

// MARK: UITableViewDelegate
extension ContactViewController: UITableViewDataSource {
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowsCount(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            ContactTableCell.defaultReuseIdentifier) as? TableViewCell {
            cell.configure(self.viewModel.cellModel(at: indexPath))
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: UITableViewDelegate
extension ContactViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDelegate
extension ContactViewController: ContactViewModelProtocol {
    
    func showOpenSettingsAlert() {
        
        let message = "Damn, you need to give me access of your contacts to that I can scan them all."
        
        let interfaceList = [ActionInterface(title: "No"), ActionInterface(title: "Yes")]
        self.showAlertController(title: "Contact Access",
                                 message: message,
                                 preferredStyle: .alert,
                                 actionInterfaceList: interfaceList) { (interface) in
            if interface.title == "Yes" {
                let settingsString = UIApplication.openSettingsURLString
                UIApplication.shared.open(URL(string: settingsString)!)
            }
        }
    }
    
}
