//
//  EmployeeProfileViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxCocoa

class EmployeeProfileViewController: BaseViewController {
    
    var viewModel: EmployeeProfileViewModel?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var profileRole: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        super.bind()
        
        viewModel?.employeeRelay.asDriver().drive(onNext: { [weak self] employee in
            guard let employee = employee else { return }
            self?.profileTitle.text = employee.fullName
            self?.profileRole.text = employee.jobTitle
            guard let imageUrl = employee.imageUrl else { return }
            self?.viewModel?.imageManager.fetchImage(imageUrl, { image in
                guard let image = image else { return }
                self?.profileImageView.image = image
            })
        }).disposed(by: disposeBag)
        
        viewModel?.loadingRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayLoading()
        }).disposed(by: disposeBag)
        
        viewModel?.endLoadingRelay.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayEndLoading()
        }).disposed(by: disposeBag)
        
        viewModel?.settingsRelay.asDriver().drive(tableView.rx.items(cellIdentifier: "EmployeeProfileSettingCell")) { row, item, cell in
            cell.textLabel?.text = item.localizedTitle
            cell.textLabel?.textColor = item.titleColor
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(EmployeeProfileSetting.self).asDriver().drive(onNext: { [weak self] setting in
            switch setting {
            case .changeImage:
                self?.pickImage()
            case .deleteProfile:
                return
            }
        }).disposed(by: disposeBag)
        
        signOutButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.signOut({ signedOut in
                guard signedOut else { return }
                self?.coordinator?.coordinateLogout()
            })
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.back()
        }).disposed(by: disposeBag)
    }
}

private extension EmployeeProfileViewController {
    
    private func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension EmployeeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel?.changeProfileImage(image, { [weak self] changedImage in
            guard let image = changedImage else { return }
            self?.profileImageView.image = image
        })
    }
}
