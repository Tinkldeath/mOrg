//
//  ControlViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxRelay
import RxCocoa

class ControlCell: UICollectionViewCell {
    
    var sector: ControlSector? {
        didSet {
            controlTitle.text = sector?.localizedTitle
        }
    }
    
    @IBOutlet private weak var controlTitle: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 2
    }
}

class ControlViewController: BaseViewController {
    
    private let controlSectors = BehaviorRelay<[ControlSector]>(value: ControlSector.allCases)

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    override func bind() {
        super.bind()
        
        controlSectors.asDriver().drive(collectionView.rx.items(cellIdentifier: "ControlCell", cellType: ControlCell.self)) { row, item, cell in
            cell.sector = item
        }.disposed(by: disposeBag)
        
        profileButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateBusinessProfile()
        }).disposed(by: disposeBag)
    }
}
