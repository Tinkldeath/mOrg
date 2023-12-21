//
//  BusinessProfileViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxCocoa

class BusinessProfileViewController: BaseViewController {
    
    var viewModel: BusinessProfileViewModel?
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileTitle: UILabel!
    @IBOutlet private weak var profileAdress: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var logoutButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        super.bind()
        
        viewModel?.titleRelay.asDriver().drive(profileTitle.rx.text).disposed(by: disposeBag)
        viewModel?.adressRelay.asDriver().drive(profileAdress.rx.text).disposed(by: disposeBag)
        
        viewModel?.profileSettingsRelay.asDriver().drive(tableView.rx.items(cellIdentifier: "BusinessProfileSettingCell")) { row, item, cell in
            cell.textLabel?.text = item.localizedTitle
            cell.textLabel?.textColor = item.titleColor
        }.disposed(by: disposeBag)
        
        viewModel?.loadingRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayLoading()
        }).disposed(by: disposeBag)
        
        viewModel?.endLoadingRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayEndLoading()
        }).disposed(by: disposeBag)
        
        viewModel?.inviteCodeRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] code in
            UIPasteboard.general.string = code
            self?.presentFastAlert("Copied to clipboard")
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(BusinessProfileSetting.self).asDriver().drive(onNext: { [weak self] setting in
            self?.viewModel?.didSelectSetting(setting)
            guard setting == .changeImage else { return }
            self?.pickImage()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.back()
        }).disposed(by: disposeBag)
        
        logoutButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.signOut({ signedOut in
                guard signedOut else { return }
                self?.coordinator?.coordinateLogout()
            })
        }).disposed(by: disposeBag)
    }
}

private extension BusinessProfileViewController {
    
    private func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension BusinessProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel?.changeProfileImage(image)
    }
}
