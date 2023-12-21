//
//  SignInViewController.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseInputViewController {
    
    var viewModel: SignInViewModel?
    
    @IBOutlet private weak var signUpAsBusinessButton: UIButton!
    @IBOutlet private weak var signInAsBusinessButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var privacyButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var signInAsEmployeeButton: UIButton!
    @IBOutlet private weak var signUpAsEmployeeButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind() {
        super.bind()
        
        viewModel?.isInputValid.asDriver().drive(signInAsBusinessButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel?.isInputValid.asDriver().drive(signInAsEmployeeButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel?.signInStartEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayLoading()
        }).disposed(by: disposeBag)
        
        signInAsBusinessButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel?.signInAsBusiness()
        }).disposed(by: disposeBag)
        
        signInAsEmployeeButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel?.signInAsEmployee()
        }).disposed(by: disposeBag)
        
        signUpAsBusinessButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateSignUpAsBusiness()
        }).disposed(by: disposeBag)
        
        signUpAsEmployeeButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateSignUpAsEmployee()
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.changed.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel?.enterInput(.init(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? ""))
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.changed.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel?.enterInput(.init(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? ""))
        }).disposed(by: disposeBag)
        
        privacyButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinatePrivacy()
        }).disposed(by: disposeBag)
        
        termsButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateTermsOfUse()
        }).disposed(by: disposeBag)
        
        viewModel?.signInBusinessEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] business, message in
            self?.displayEndLoading()
            if let business = business {
                self?.presentAlert("Signed in", message, {
                    self?.coordinator?.coordinateUserFlow(for: business)
                })
            } else {
                self?.presentAlert("Error", message, {
                    
                })
            }
        }).disposed(by: disposeBag)
        
        viewModel?.signInEmployeeEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] employee, message in
            self?.displayEndLoading()
            if let employee = employee {
                self?.presentAlert("Signed in", message, {
                    self?.coordinator?.coordinateUserFlow(for: employee)
                })
            } else {
                self?.presentAlert("Error", message, {
                    
                })
            }
        }).disposed(by: disposeBag)
    }

}
