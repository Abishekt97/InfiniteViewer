//
//  APIResponseHandler.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

protocol APIResponseHandler: AnyObject {
    
    func handleErrorResponse(_ error: String)
    func sucessResponse()

}
