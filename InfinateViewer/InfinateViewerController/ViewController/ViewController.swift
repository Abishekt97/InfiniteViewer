//
//  ViewController.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

class ViewController: UIViewController {

    lazy var collectionView: UICollectionView! = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: VerticalCollectionViewCell.self))
        return collectionView
        
    }()
    
    lazy var indicatorView: UIActivityIndicatorView! = {
        
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.tintColor = .black
        indicatorView.hidesWhenStopped = true
        return indicatorView
        
    }()
        
    lazy var controller: Controller! = Controller()
    var infiniteScrollingBehaviour: InfiniteScrollingBehaviour!

    override func loadView() {
        super.loadView()
        
        addContraint()
        view.backgroundColor = .white
        loadAPI()
        
    }
    
}

extension ViewController{
    
    func loadAPI(){
        
        controller.albumDelegate = self
        controller.callAPI()
        self.indicatorView.isHidden = false
        indicatorView.startAnimating()
        
    }
}

extension ViewController: APIResponseHandler{
    
    func handleErrorResponse(_ error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.indicatorView.stopAnimating()
        }
    }
    
    func sucessResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.indicatorView.stopAnimating()
            let configuration = CollectionViewConfiguration(layoutType: .fixedSize(sizeValue: 230, lineSpacing: 10), scrollingDirection: .vertical)
            self.infiniteScrollingBehaviour = InfiniteScrollingBehaviour(withCollectionView: self.collectionView, andData: self.controller.albums, delegate: self, configuration: configuration)
        }
    }

}

extension ViewController {
    
    func addContraint(){
        
        view.addSubview(collectionView)
        view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        ])
        
    }
    
}

extension ViewController: InfiniteScrollingBehaviourDelegate{
    
    func configuredCell(forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VerticalCollectionViewCell.self), for: indexPath) as! VerticalCollectionViewCell
        cell.controller = controller
        guard let album = data as? AlbumModel else {
            return cell
        }
        cell.album = album
        return cell
        
    }
    
}
