//
//  BaseViewController.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import UIKit
import RxSwift
import RxCocoa


class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapViewSpace))
        return gesture
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
    
    func setupViewController() {
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeGesture)
    }
    
    func bind() {  }
    
    @objc func didTapViewSpace() {
        view.endEditing(true)
    }
    
    @objc func didSwipeLeft() {  }
    
}
