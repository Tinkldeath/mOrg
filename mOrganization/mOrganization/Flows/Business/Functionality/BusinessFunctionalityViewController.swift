//
//  BusinessFunctionalityViewController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit
import RxRelay
import RxCocoa

class BunsinessFunctionalitySectorCell: UICollectionViewCell {
    
    var sector: FunctionalitySector? {
        didSet {
            sectorImageView.image = sector?.associatedImage
            sectorTitle.text = sector?.localizedTitle
        }
    }
    
    @IBOutlet private weak var sectorImageView: UIImageView!
    @IBOutlet private weak var sectorTitle: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = 2
    }
}

class BusinessFunctionalityViewController: BaseViewController {

    private let sectorsRelay = BehaviorRelay<[FunctionalitySector]>(value: FunctionalitySector.allCases)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var settingsButton: UIBarButtonItem!
    @IBOutlet private weak var profileButton: UIBarButtonItem!
    
    override func bind() {
        super.bind()
        
        sectorsRelay.asDriver().drive(collectionView.rx.items(cellIdentifier: "BunsinessFunctionalitySectorCell", cellType: BunsinessFunctionalitySectorCell.self)) { row, item, cell in
            cell.sector = item
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(FunctionalitySector.self).asDriver().drive(onNext: { [weak self] sector in
            self?.coordinator?.coordinateFunctionalitySector(sector)
        }).disposed(by: disposeBag)
        
        profileButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.coordinator?.coordinateBusinessProfile()
        }).disposed(by: disposeBag)
    }
}
