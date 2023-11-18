//
//  SignUpViewController.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import UIKit
import RxSwift
import RxCocoa


class SignUpViewController: BaseViewController, AuthRoutable {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var setOrganizationImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    var viewModel: SignUpViewModel?
    var coordinator: AuthCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        organizationImageView.layer.borderColor = UIColor.label.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    override func bind() {
        super.bind()
        
        viewModel?.isValidInput.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] value in
            self?.startButton.isEnabled = value
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateSignIn()
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(titleTextField.rx.text, typeSegmentedControl.rx.selectedSegmentIndex, emailTextField.rx.text, adressTextField.rx.text, passwordTextField.rx.text).subscribe(onNext: { [weak self] _, _, _, _, _ in
            self?.inputToViewModel()
        }).disposed(by: disposeBag)
        
        setOrganizationImageButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self?.present(imagePicker, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel?.signUpStartEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.displayLoading()
        }).disposed(by: disposeBag)
        
        viewModel?.signUpEndEvent.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] completed, message in
            self?.displayEndLoading()
            let alertTitle = completed ? "Success" : "Error"
            self?.presentAlert(alertTitle, message, {
                self?.coordinator?.coordinateUserFlow()
            })
        }).disposed(by: disposeBag)
        
        startButton.rx.tap.asDriver(onErrorDriveWith: .never()).drive(onNext: { [weak self] _ in
            self?.viewModel?.signUp()
        }).disposed(by: disposeBag)
    }
    
    override func didSwipeLeft() {
        super.didSwipeLeft()
        coordinator?.coordinateSignIn()
    }
    
    private func inputToViewModel() {
        guard let type = typeSegmentedControl.titleForSegment(at: typeSegmentedControl.selectedSegmentIndex) else { return }
        viewModel?.enterInput(.init(title: titleTextField.text ?? "", type: type, adress: adressTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", image: organizationImageView.image))
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        organizationImageView.image = image
        picker.dismiss(animated: true)
        inputToViewModel()
    }
    
}
