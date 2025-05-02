//
//  MyPageCollectionReusableView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/28/25.
//

import UIKit
import SnapKit

protocol MyPageCollectionHeaderViewDelegate: AnyObject {
    func moreButtonTapped(in index: Int)
}

final class MyPageCollectionHeaderView: UICollectionReusableView {
    
    static var elementKind: String {
        return UICollectionView.elementKindSectionHeader
    }
    
    var sectionIndex: Int = 0
    
    weak var delegate: MyPageCollectionHeaderViewDelegate?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기 >", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        [titleLabel, moreButton].forEach { view in
            addSubview(view)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    @objc func moreButtonTapped() {
        print("moreButtonTapped")
        delegate?.moreButtonTapped(in: self.sectionIndex)
    }
    
    func configure(section: MyPageCollectionSection, count: Int) {
        var title = "해당 없음"
        if case section = .favorite {
            title = "내가 찜한 영화"
        } else if case section = .reservation {
            title = "예매 내역"
        }
        self.titleLabel.text = title
        self.moreButton.isHidden = count > 2 ? false : true
    }
}

