//
//  CollectionViewConfiguration.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

public struct CollectionViewConfiguration {
    public let scrollingDirection: UICollectionView.ScrollDirection
    public var layoutType: LayoutType
    public static let `default` = CollectionViewConfiguration(layoutType: .numberOfCellOnScreen(5), scrollingDirection: .horizontal)
    
    public init(layoutType: LayoutType, scrollingDirection: UICollectionView.ScrollDirection) {
        self.layoutType = layoutType
        self.scrollingDirection = scrollingDirection
    }
}
