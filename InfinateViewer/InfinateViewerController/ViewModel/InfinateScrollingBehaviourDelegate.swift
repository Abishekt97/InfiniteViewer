//
//  InfinateScrollingBehaviourDelegate.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

public protocol InfiniteScrollingBehaviourDelegate: AnyObject {
    func configuredCell(forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell
    func didSelectItem(atIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> Void
    func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour)
    func verticalPaddingForHorizontalInfiniteScrollingBehaviour(behaviour: InfiniteScrollingBehaviour) -> CGFloat
    func horizonalPaddingForHorizontalInfiniteScrollingBehaviour(behaviour: InfiniteScrollingBehaviour) -> CGFloat
}

public extension InfiniteScrollingBehaviourDelegate {
    func didSelectItem(atIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> Void { }
    func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) { }
    func verticalPaddingForHorizontalInfiniteScrollingBehaviour(behaviour: InfiniteScrollingBehaviour) -> CGFloat {
        return 0
    }
    func horizonalPaddingForHorizontalInfiniteScrollingBehaviour(behaviour: InfiniteScrollingBehaviour) -> CGFloat {
        return 0
    }
}
