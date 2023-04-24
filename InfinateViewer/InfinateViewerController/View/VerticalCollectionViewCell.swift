//
//  VerticalCollectionViewCell.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView! = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HorizontalCollectionViewCell.self))
        return collectionView
        
    }()
    
    lazy var indicatorView: UIActivityIndicatorView! = {
        
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.tintColor = .black
        indicatorView.hidesWhenStopped = true
        return indicatorView
        
    }()
    
    lazy var titleLabel: UILabel! = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
        
    }()
    
    var infiniteScrollingBehaviour: InfiniteScrollingBehaviour!
    var controller: Controller!
    
    var album: AlbumModel?{
        didSet{
            setCollectionView(album)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraint()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VerticalCollectionViewCell{
    
    func setConstraint(){
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func setCollectionView(_ album: AlbumModel?){
        guard let albumData = album else {
            return
        }
        self.titleLabel.text = albumData.title ?? ""
        guard let photoAlbums = controller.albumsPhotos[albumData] else {
            loadAPI(albumData)
            return
        }
        self.indicatorView.stopAnimating()
       let configuration = CollectionViewConfiguration(layoutType: .fixedSize(sizeValue: 230, lineSpacing: 10), scrollingDirection: .horizontal)
        infiniteScrollingBehaviour = InfiniteScrollingBehaviour(withCollectionView: collectionView, andData: photoAlbums , delegate: self, configuration: configuration)
       
    }
    
    func loadAPI(_ album: AlbumModel){
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        controller.callAPIForAlbumPhoto(album) { error in
            guard let error = error else{
                DispatchQueue.main.async { [weak self] in
                    self?.setCollectionView(album)
                    self?.indicatorView.stopAnimating()
                }
                return
            }
            debugPrint(error)
        }
    }
    
}

extension VerticalCollectionViewCell: InfiniteScrollingBehaviourDelegate{
    
    func configuredCell(forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HorizontalCollectionViewCell.self), for: indexPath) as! HorizontalCollectionViewCell
        cell.alubm = data as? AlbumPhotoModel
        return cell
        
    }
    
}
