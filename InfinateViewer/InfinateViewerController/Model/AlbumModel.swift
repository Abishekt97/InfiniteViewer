//
//  AlbumModel.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

struct AlbumModel: Codable {
    
    let userID: String?
    let id: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.userID = try? container?.decodeIfPresent(String.self, forKey: .userID)
        self.id = try? container?.decodeIfPresent(Int.self, forKey: .id)
        self.title = try? container?.decodeIfPresent(String.self, forKey: .title)
    }
    
}

extension AlbumModel: Hashable{
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension AlbumModel: InfiniteScollingData { }
