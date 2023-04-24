//
//  UserDefaultsModel.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

struct UserDefaultsModel{
    
    static var standard = UserDefaultsModel()
    
    @UserDefaultValue(key: "AlbumDownloadedResponse", defaultValue: [])
    var albumModel: [AlbumModel]
    
    @UserDefaultValue(key: "AlbumPhotoDownloadedVideos", defaultValue: [:])
    var albumPhotoModel: [AlbumModel: [AlbumPhotoModel]]

}
