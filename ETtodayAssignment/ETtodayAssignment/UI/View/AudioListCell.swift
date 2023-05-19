//
//  AudioListCell.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit

final class AudioListCell: UICollectionViewCell {
    static let identifier = "\(AudioListCell.self)"
    
    let longDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let audioImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let playImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.setImage(UIImage(systemName: "pause.circle"), for: .selected)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .darkGray
        button.isUserInteractionEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var prepareForReuseHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        prepareForReuseHandler?()
    }
    
    private func setUpUI() {
        contentView.addSubviews([audioImageView, longDescriptionLabel])
        audioImageView.addSubview(playImageView)
        
        audioImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        longDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(audioImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10).priority(999)
        }
        
        playImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }
}
