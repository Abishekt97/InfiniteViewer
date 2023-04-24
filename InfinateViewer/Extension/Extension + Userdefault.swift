//
//  Extension + Userdefault.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

extension UserDefaults{
    
    static func setAPILoaded(for url: String){
        standard.set(true, forKey: url)
    }
    
    static func apiLoaded(for url: String) -> Bool{
        return standard.bool(forKey: url)
    }
    
}
