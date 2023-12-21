//
//  BusinessViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxRelay
import RxCocoa

class BusinessCell: UICollectionViewCell {
    
    var sector: BusinessSector? {
        didSet {
            businessImageView.image = sector?.associatedImage
            businessLabel.text = sector?.localizedTitle
        }
    }
    
    @IBOutlet private weak var businessImageView: UIImageView!
    @IBOutlet private weak var businessLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 2
    }
}

class BusinessViewController: BaseViewController {
    
    private let sectorsRelay = BehaviorRelay<[BusinessSector]>(value: BusinessSector.allCases)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var profileButton: UIBarButtonItem!
    
    override func bind() {
        super.bind()
        
        sectorsRelay.asDriver().drive(collectionView.rx.items(cellIdentifier: "BusinessCell", cellType: BusinessCell.self)) { row, item, cell in
            cell.sector = item
        }.disposed(by: disposeBag)
        
        profileButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateBusinessProfile()
        }).disposed(by: disposeBag)
    }
}
