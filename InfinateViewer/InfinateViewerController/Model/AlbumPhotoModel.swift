//
//  AlbumPhotoModel.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

struct AlbumPhotoModel: Codable {
    let albumID: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.albumID =  try? container?.decodeIfPresent(Int.self, forKey: .albumID)
        self.id =  try? container?.decodeIfPresent(Int.self, forKey: .id)
        self.title =  try? container?.decodeIfPresent(String.self, forKey: .title)
        self.url =  try? container?.decode(String.self, forKey: .url)
        self.thumbnailURL =  try? container?.decode(String.self, forKey: .thumbnailURL)
    }
    
}

extension AlbumPhotoModel: InfiniteScollingData { }
