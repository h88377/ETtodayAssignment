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
        button.isUserInteractionEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setUpUI() {
        contentView.addSubviews([audioImageView, longDescriptionLabel])
        audioImageView.addSubview(playImageView)
        
        audioImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        longDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(audioImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        playImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
    }
}

private extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
