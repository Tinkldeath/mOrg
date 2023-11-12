//
//  SignInViewController.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import UIKit
import RxSwift
import RxCocoa


class SignInViewController: BaseViewController, AuthRoutable {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    
    private var viewModel: SignInViewModel = SignInViewModel()
    var coordinator: AuthCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind() {
        super.bind()
        
        viewModel.isInputValid.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] value in
            self?.signInButton.isEnabled = value
        }).disposed(by: disposeBag)
        
        signUpButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateSignUp()
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.changed.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel.enterInput(.init(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? ""))
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.changed.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel.enterInput(.init(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? ""))
        }).disposed(by: disposeBag)
        
        privacyButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinatePrivacy()
        }).disposed(by: disposeBag)
        
        termsButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateTermsOfUse()
        }).disposed(by: disposeBag)
    }

}
