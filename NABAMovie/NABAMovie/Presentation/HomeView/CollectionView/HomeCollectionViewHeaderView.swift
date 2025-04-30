//
//  HomeCollectionViewHeaderView.swift
//  NABAMovie
//
//  Created by 박주성 on 4/29/25.
//

import UIKit
import SnapKit

final class HomeCollectionViewHeaderView: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        String(describing: HomeCollectionViewHeaderView.self)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with title: String) {
        titleLabel.text = title
    }
}

private extension HomeCollectionViewHeaderView {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        self.addSubview(titleLabel)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
