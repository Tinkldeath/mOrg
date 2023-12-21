//
//  EmployeeMailViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxCocoa

class EmployeeMailCell: UITableViewCell {
    
    var mail: Mail? {
        didSet {
            guard let mail = mail else { return }
            senderName.text = Ciper.unseal(mail.header)
            preview.text = Ciper.unseal(mail.content)
        }
    }
    
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var preview: UILabel!
    
}

class EmployeeMailViewController: BaseViewController {
    
    private var viewModel: MailViewModel = MailViewModel(DefaultManagerFactory.shared)
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var profileButton: UIBarButtonItem!
    
    override func bind() {
        super.bind()
        
        viewModel.mail.asDriver().drive(tableView.rx.items(cellIdentifier: "EmployeeMailCell", cellType: EmployeeMailCell.self)) { row, item, cell in
            cell.mail = item
        }.disposed(by: disposeBag)
        
        addButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateAddMail()
        }).disposed(by: disposeBag)
        
        profileButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateEmployeeProfile()
        }).disposed(by: disposeBag)
    }
}
