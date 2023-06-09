//
//  InfinateViewerBehaviour.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

public protocol InfiniteScollingData { }

public class InfiniteScrollingBehaviour: NSObject {
    fileprivate var cellSize: CGFloat = 0.0
    fileprivate var padding: CGFloat = 0.0
    fileprivate var numberOfBoundaryElements = 0
    fileprivate(set) public weak var collectionView: UICollectionView!
    fileprivate(set) public weak var delegate: InfiniteScrollingBehaviourDelegate?
    fileprivate(set) public var dataSet: [InfiniteScollingData]
    fileprivate(set) public var dataSetWithBoundary: [InfiniteScollingData] = []
    
    fileprivate var collectionViewBoundsValue: CGFloat {
        get {
            switch collectionConfiguration.scrollingDirection {
            case .horizontal:
                return collectionView.bounds.size.width
            case .vertical:
                return collectionView.bounds.size.height
            @unknown default:
                fatalError()
            }
        }
    }
    
    fileprivate var scrollViewContentSizeValue: CGFloat {
        get {
            switch collectionConfiguration.scrollingDirection {
            case .horizontal:
                return collectionView.contentSize.width
            case .vertical:
                return collectionView.contentSize.height
            @unknown default:
                fatalError()
            }
        }
    }
    
    fileprivate(set) public var collectionConfiguration: CollectionViewConfiguration
    
    public init(withCollectionView collectionView: UICollectionView, andData dataSet: [InfiniteScollingData], delegate: InfiniteScrollingBehaviourDelegate?, configuration: CollectionViewConfiguration = .default) {
        self.collectionView = collectionView
        self.dataSet = dataSet
        self.collectionConfiguration = configuration
        self.delegate = delegate
        super.init()
        configureBoundariesForInfiniteScroll()
        configureCollectionView()
        scrollToFirstElement()
    }
    
    
    private func configureBoundariesForInfiniteScroll() {
        dataSetWithBoundary = dataSet
        calculateCellWidth()
        let absoluteNumberOfElementsOnScreen = ceil(collectionViewBoundsValue/cellSize)
        numberOfBoundaryElements = Int(absoluteNumberOfElementsOnScreen)
        addLeadingBoundaryElements()
        addTrailingBoundaryElements()
    }
    
    private func calculateCellWidth() {
        switch collectionConfiguration.layoutType {
        case .fixedSize(let sizeValue, let padding):
            cellSize = sizeValue
            self.padding = padding
        case .numberOfCellOnScreen(let numberOfCellsOnScreen):
            cellSize = (collectionViewBoundsValue/numberOfCellsOnScreen.cgFloat)
            padding = 0
        }
    }
    
    private func addLeadingBoundaryElements() {
        for index in stride(from: numberOfBoundaryElements, to: 0, by: -1) {
            let indexToAdd = (dataSet.count - 1) - ((numberOfBoundaryElements - index)%dataSet.count)
            let data = dataSet[indexToAdd]
            dataSetWithBoundary.insert(data, at: 0)
        }
    }
    
    private func addTrailingBoundaryElements() {
        for index in 0..<numberOfBoundaryElements {
            let data = dataSet[index%dataSet.count]
            dataSetWithBoundary.append(data)
        }
    }
    
    private func configureCollectionView() {
        guard let _ = self.delegate else { return }
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = collectionConfiguration.scrollingDirection
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func scrollToFirstElement() {
        scroll(toElementAtIndex: 0)
    }
    
    
    public func scroll(toElementAtIndex index: Int) {
        let boundaryDataSetIndex = indexInBoundaryDataSet(forIndexInOriginalDataSet: index)
        let indexPath = IndexPath(item: boundaryDataSetIndex, section: 0)
        let scrollPosition: UICollectionView.ScrollPosition = collectionConfiguration.scrollingDirection == .horizontal ? .left : .top
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
    }
    
    public func indexInOriginalDataSet(forIndexInBoundaryDataSet index: Int) -> Int {
        let difference = index - numberOfBoundaryElements
        if difference < 0 {
            let originalIndex = dataSet.count + difference
            return abs(originalIndex % dataSet.count)
        } else if difference < dataSet.count {
            return difference
        } else {
            return abs((difference - dataSet.count) % dataSet.count)
        }
    }
    
    public func indexInBoundaryDataSet(forIndexInOriginalDataSet index: Int) -> Int {
        return index + numberOfBoundaryElements
    }
    
    
    public func reload(withData dataSet: [InfiniteScollingData]) {
        self.dataSet = dataSet
        configureBoundariesForInfiniteScroll()
        collectionView.reloadData()
        scrollToFirstElement()
    }
    
    public func updateConfiguration(configuration: CollectionViewConfiguration) {
        collectionConfiguration = configuration
        configureBoundariesForInfiniteScroll()
        configureCollectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.reloadData()
            self.scrollToFirstElement()
        }
    }
}

extension InfiniteScrollingBehaviour: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch (collectionConfiguration.scrollingDirection, delegate) {
        case (.horizontal, .some(let delegate)):
            let inset = delegate.verticalPaddingForHorizontalInfiniteScrollingBehaviour(behaviour: self)
            return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        case (.vertical, .some(let delegate)):
            let inset = delegate.horizonalPaddingForHorizontalInfiniteScrollingBehaviour(behaviour: self)
            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        case (_, _):
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch (collectionConfiguration.scrollingDirection, delegate) {
        case (.horizontal, .some(_)):
            return CGSize(width: cellSize, height: cellSize)
        case (.vertical, .some(_)):
            return CGSize(width: collectionView.bounds.width, height: cellSize)
        case (.horizontal, _):
            return CGSize(width: cellSize, height: collectionView.bounds.size.height)
        case (.vertical, _):
            return CGSize(width: collectionView.bounds.size.width, height: cellSize)
        @unknown default:
            fatalError()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let originalIndex = indexInOriginalDataSet(forIndexInBoundaryDataSet: indexPath.item)
        delegate?.didSelectItem(atIndexPath: indexPath, originalIndex: originalIndex, andData: dataSetWithBoundary[indexPath.item], inInfiniteScrollingBehaviour: self)
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let boundarySize = numberOfBoundaryElements.cgFloat * cellSize + (numberOfBoundaryElements.cgFloat * padding)
        let contentOffsetValue = collectionConfiguration.scrollingDirection == .horizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y
        if contentOffsetValue >= (scrollViewContentSizeValue - boundarySize) {
            let offset = boundarySize - padding
            let updatedOffsetPoint = collectionConfiguration.scrollingDirection == .horizontal ?
                CGPoint(x: offset, y: 0) : CGPoint(x: 0, y: offset)
            scrollView.contentOffset = updatedOffsetPoint
        } else if contentOffsetValue <= 0 {
            let boundaryLessSize = dataSet.count.cgFloat * cellSize + (dataSet.count.cgFloat * padding)
            let updatedOffsetPoint = collectionConfiguration.scrollingDirection == .horizontal ?
                CGPoint(x: boundaryLessSize, y: 0) : CGPoint(x: 0, y: boundaryLessSize)
            scrollView.contentOffset = updatedOffsetPoint
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.didEndScrolling(inInfiniteScrollingBehaviour: self)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            delegate?.didEndScrolling(inInfiniteScrollingBehaviour: self)
        }
    }
    
}

extension InfiniteScrollingBehaviour: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSetWithBoundary.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let delegate = self.delegate else {
            return UICollectionViewCell()
        }
        let originalIndex = indexInOriginalDataSet(forIndexInBoundaryDataSet: indexPath.item)
        return delegate.configuredCell(forItemAtIndexPath: indexPath, originalIndex: originalIndex, andData: dataSetWithBoundary[indexPath.item], forInfiniteScrollingBehaviour: self)
    }
}

