//
//  SongData.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 18/06/26.
//

import Foundation

struct Song: Identifiable {
    let id = UUID()
    
    let audioFile: String
    let albumImage: String
    let title: String
    let genre: String
}
