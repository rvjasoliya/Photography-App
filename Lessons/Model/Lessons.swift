//
//  Lessons.swift
//  Lessons
//
//  Created by iMac on 03/03/23.
//

import Foundation

struct Lessons: Codable, Hashable {
    
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let video_url: String
    
    var isVideoDownload: Bool? = false
    var isVideoDownloading: Bool? = false
    var progress: Double? = 0
    var taskIdentifier: Int? = 0
    
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
    
}
