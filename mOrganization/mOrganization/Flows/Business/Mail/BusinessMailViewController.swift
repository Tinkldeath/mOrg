//
//  BusinessMailViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxCocoa

class BusinessMailCell: UITableViewCell {
    
    var mail: Mail? {
        didSet {
            guard let mail = mail else { return }
            mailHeader.text = Ciper.unseal(mail.header)
            mailTheme.text = Ciper.unseal(mail.theme)
        }
    }
    
    @IBOutlet private weak var senderImageView: UIImageView!
    @IBOutlet private weak var mailHeader: UILabel!
    @IBOutlet private weak var mailTheme: UILabel!
}

class BusinessMailViewController: BaseViewController {
    
    var viewModel: MailViewModel?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        super.bind()
        
        viewModel?.mail.asDriver().drive(tableView.rx.items(cellIdentifier: "MailCell", cellType: BusinessMailCell.self)) { row, item, cell in
            cell.mail = item
        }.disposed(by: disposeBag)
        
        addButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateAddMail()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.back()
        }).disposed(by: disposeBag)
    }
}
