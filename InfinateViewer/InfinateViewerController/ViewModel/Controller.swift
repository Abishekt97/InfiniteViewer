//
//  Controller.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

class Controller: NSObject{
    
    weak var albumDelegate: APIResponseHandler?
    
    var albums: [AlbumModel]! = UserDefaultsModel.standard.albumModel
    var albumsPhotos: [AlbumModel: [AlbumPhotoModel]]! = UserDefaultsModel.standard.albumPhotoModel

    func callAPI(){
        if albums.isEmpty{
            InfinateSession.shared.apiCall(.albums, data: [AlbumModel].self) { [weak self] data, error in
                if let error = error{
                    self?.albumDelegate?.handleErrorResponse(error)
                }else{
                    self?.albums = data
                    UserDefaultsModel.standard.albumModel = data ?? []
                    self?.albumDelegate?.sucessResponse()
                }
            }
        }else{
            albumDelegate?.sucessResponse()
        }
    }
    
    func callAPIForAlbumPhoto(_ album: AlbumModel, completionHandler: @escaping @Sendable (String?) -> Void){
        
        InfinateSession.shared.apiCall(.photos(["albumId" : String(album.id ?? 0)]), data: [AlbumPhotoModel].self) { [weak self] data, error in
            if let error = error{
                completionHandler(error)
            }else{
                self?.albumsPhotos[album] = data
                UserDefaultsModel.standard.albumPhotoModel[album] = data
                completionHandler(nil)
            }
        }
         
    }
    
}
