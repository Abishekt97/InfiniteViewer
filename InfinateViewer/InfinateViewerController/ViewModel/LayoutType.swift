//
//  LayoutType.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

public enum LayoutType {
    case fixedSize(sizeValue: CGFloat, lineSpacing: CGFloat)
    case numberOfCellOnScreen(Double)
}
