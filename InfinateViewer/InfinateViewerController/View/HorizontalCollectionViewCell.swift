//
//  HorizontalCollectionViewCell.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: LoaderImageView! = {
        
        let imageView = LoaderImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.setCardLayer()
        return imageView
        
    }()
    
    lazy var titleLabel: UILabel! = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
        
    }()
    
    var alubm: AlbumPhotoModel?{
        didSet{
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setConstraint()
        contentView.setCardLayer()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HorizontalCollectionViewCell{
    
    func configureCell(){
        titleLabel.text = alubm?.title ?? ""
        guard let thumbnailURL = alubm?.thumbnailURL, let url = URL(string: thumbnailURL) else {
            return
        }
        imageView.loadImageWithUrl(url)
        
    }
    
}

extension HorizontalCollectionViewCell{
    
    func setConstraint(){
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

        ])

    }
    
}
