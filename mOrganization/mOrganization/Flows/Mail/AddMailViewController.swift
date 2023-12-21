//
//  AddMailViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxCocoa
import RxGesture

class RecieverCell: UITableViewCell {
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .blue : .systemBackground
        }
    }
    
    var reciever: MailReciever? {
        didSet {
            guard let reciever = reciever else { return }
            personFullName.text = reciever.title
            personRole.text = reciever.subtitle
        }
    }
    
    @IBOutlet private weak var personImageView: UIImageView!
    @IBOutlet private weak var personFullName: UILabel!
    @IBOutlet private weak var personRole: UILabel!
    
    func setImage(_ image: UIImage) {
        personImageView.image = image
    }
}

class AddMailViewController: BaseInputViewController {
    
    var viewModel: AddMailViewModel?

    @IBOutlet private weak var headerTextField: UITextField!
    @IBOutlet private weak var themeTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var addFileButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var sendButton: UIButton!
    
    override func bind() {
        super.bind()
        
        viewModel?.isValidInput.asDriver().drive(sendButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel?.recievers.asDriver().drive(tableView.rx.items(cellIdentifier: "RecieverCell", cellType: RecieverCell.self)) { [weak self] row, item, cell in
            cell.reciever = item
            guard let imageUrl = item.imageUrl else { return }
            self?.viewModel?.imageManager.fetchImage(imageUrl, { image in
                guard let image = image else { return }
                cell.setImage(image)
            })
        }.disposed(by: disposeBag)
        
        viewModel?.loadingRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayLoading()
        }).disposed(by: disposeBag)
        
        viewModel?.mailSentRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] sent in
            self?.displayEndLoading()
            if sent {
                self?.coordinator?.back()
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            self?.viewModel?.didSelectReciever(indexPath)
        }).disposed(by: disposeBag)
        
        headerTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        themeTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        contentTextView.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        sendButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.send()
        }).disposed(by: disposeBag)
    }
}

private extension AddMailViewController {
    
    private func inputToViewModel() {
        viewModel?.enterInput(.init(header: headerTextField.text.orEmpty(), theme: themeTextField.text.orEmpty(), text: contentTextView.text.orEmpty(), reciever: ""))
    }
}
