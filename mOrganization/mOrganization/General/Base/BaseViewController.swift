//
//  BaseViewController.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Base class extends life cycle
class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var coordinator: AppCoordinator?
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.tintColor = .label
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return indicator
    }()
        
    private lazy var swipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        return gesture
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        bind()
    }
    
    func setupViewController() {  }
    
    func bind() {  }
    
    func displayLoading() {
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    func displayEndLoading() {
        view.alpha = 1
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    @objc func didSwipeLeft() {  }
    
    func presentAlert(_ title: String?, _ message: String?, _ completion: @escaping () -> ()) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        self.present(ac, animated: true)
    }
    
    func presentFastAlert(_ title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        present(ac, animated: true)
        ac.dismiss(animated: true)
    }
}

// MARK: - Base class for input (text fields, pickers etc.)
class BaseInputViewController: BaseViewController {
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapViewSpace))
        return gesture
    }()
    
    @objc func didTapViewSpace() {
        view.endEditing(true)
    }
    
    override func setupViewController() {
        super.setupViewController()
        
        view.addGestureRecognizer(tapGesture)
    }
}
