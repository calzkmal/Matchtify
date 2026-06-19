//
//  SongData.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 18/06/26.
//

import Foundation

struct Song: Identifiable {
    var id: String {
        audioFile
    }
    
    let audioFile: String
    let albumImage: String
    let title: String
    let artist: String
    let genre: String
    let year: Int
}
