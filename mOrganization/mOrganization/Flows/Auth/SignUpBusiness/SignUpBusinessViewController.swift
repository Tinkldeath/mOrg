//
//  SignUpBusinessViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpBusinessViewController: BaseInputViewController {
    
    var viewModel: SignUpBusinessViewModel?
    
    @IBOutlet private weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var adressTextField: UITextField!
    @IBOutlet private weak var fieldOfActivityTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    
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
        
        viewModel?.signUpEndEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] (business, message) in
            self?.displayEndLoading()
            if let business = business {
                self?.presentAlert("Success", message, {
                    self?.coordinator?.coordinateUserFlow(for: business)
                })
            } else {
                self?.presentAlert("Error", message, {
                    
                })
            }
        }).disposed(by: disposeBag)
        
        typeSegmentedControl.rx.selectedSegmentIndex.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        titleTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        adressTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        fieldOfActivityTextField.rx.text.asDriver().drive(onNext: { [weak self] _ in
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
    }
}

private extension SignUpBusinessViewController {
    
    private func inputToViewModel() {
        guard let typeTitle = typeSegmentedControl.titleForSegment(at: typeSegmentedControl.selectedSegmentIndex), let type = Business.BusinessType.allCases.first(where: { $0.abbreviation == typeTitle }) else { return }
        self.viewModel?.enterInput(.init(title: titleTextField.text.orEmpty(), type: type, fieldOfActivity: fieldOfActivityTextField.text.orEmpty(), adress: adressTextField.text.orEmpty(), email: emailTextField.text.orEmpty(), password: passwordTextField.text.orEmpty()))
    }
}
