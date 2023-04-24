//
//  URLHandler.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

enum URLHandler{
    
    static let baseURLString = "BASE_URL"
    
    static var infoDic: [String: Any]{
        return Bundle.main.infoDictionary ?? [:]
    }
    
    static var baseURL: String{
        return infoDic[baseURLString] as! String
    }
    
    case albums
    case photos(_ param: [String: String])
    
    var rawValue: String{
        switch self {
        case .albums:
            return Self.baseURL + "albums"
        case .photos(let param):
            return urlComponentsHandler(params: param, endPoint: Self.baseURL + "photos")?.url?.absoluteString ?? ""
        }
    }
    
}

extension URLHandler{
    
    func urlComponentsHandler(params: [String: String]?, endPoint: String) -> URLComponents? {
        var urlComponend = URLComponents(string: endPoint)
        
        if let urlParams = params{
            var item = [URLQueryItem]()
            for (_, (key, value)) in urlParams.enumerated(){
                item.append(URLQueryItem(name: key, value: value))
            }
            urlComponend?.queryItems = item
        }
        return urlComponend
    }
    
}
