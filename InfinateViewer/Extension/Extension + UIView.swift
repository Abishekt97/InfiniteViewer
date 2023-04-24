//
//  Extension + UIView.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

extension UIView{
    
    func setCardLayer(){
        clipsToBounds = true
        layer.cornerRadius = 20.0
        layer.masksToBounds = true
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
    }
    
}
