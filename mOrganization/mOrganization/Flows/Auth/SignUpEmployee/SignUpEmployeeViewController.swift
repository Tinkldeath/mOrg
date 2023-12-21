//
//  SignUpEmployeeViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxCocoa

class SignUpEmployeeViewController: BaseInputViewController {
    
    var viewModel: SignUpEmployeeViewModel?
    
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var inviteCodeTextField: UITextField!
    @IBOutlet private weak var jobTitleTextField: UITextField!
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        super.bind()
        
        viewModel?.isValidInput.asDriver().drive(startButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel?.signUpStartEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayLoading()
        }).disposed(by: disposeBag)
        
        roleSegmentedControl.rx.selectedSegmentIndex.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        inviteCodeTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        jobTitleTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        fullNameTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        startButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.signUp()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.back()
        }).disposed(by: disposeBag)
        
        viewModel?.signUpEndEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] employee, message in
            self?.displayEndLoading()
            if let employee = employee {
                self?.presentAlert("Success", message, {
                    self?.coordinator?.coordinateUserFlow(for: employee)
                })
            } else {
                self?.presentAlert("Error", message, {
                    
                })
            }
        }).disposed(by: disposeBag)
    }
}

private extension SignUpEmployeeViewController {
    
    private func inputToViewModel() {
        guard let typeText = roleSegmentedControl.titleForSegment(at: roleSegmentedControl.selectedSegmentIndex), let type = Employee.EmployeeType(rawValue: typeText) else { return }
        viewModel?.enterInput(.init(type: type, businessInviteCode: inviteCodeTextField.text.orEmpty(), fullName: fullNameTextField.text.orEmpty(), jobTitle: jobTitleTextField.text.orEmpty(), email: emailTextField.text.orEmpty(), password: passwordTextField.text.orEmpty()))
    }
}
