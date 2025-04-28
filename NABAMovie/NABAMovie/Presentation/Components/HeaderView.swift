//
//  HeaderView.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import UIKit

final class HeaderView: UIView {
    
    private let titleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BrandTitleLogo(White)")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BrandLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HeaderView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = UIColor(named: "brandColor")
    }
    
    func setHierarchy() {
        [titleLogoImageView, logoImageView].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        titleLogoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(5)
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.width.equalTo(titleLogoImageView.snp.height)
        }
        
        logoImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(5)
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.width.equalTo(logoImageView.snp.height)
        }
    }
}
