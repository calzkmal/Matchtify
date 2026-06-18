//
//  SongLibrary.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 18/06/26.
//

import Foundation

struct SongLibrary {

    static let songs: [Song] = [
        "song-1_album-1_Am-I-Dreaming_Pop",
        "song-2_album-1_Self-Love_Pop",
        "song-3_album-1_Calling_Pop",
        "song-4_album-2_California-Love_Hiphop",
        "song-5_album-3_Cintamu-Sepahit-Topi-Miring_Hiphop",
        "song-6_album-4_Not-Like-Us_Hiphop",
        "song-7_album-5_Beauty-And-A-Beat_Electronic",
        "song-8_album-6_Scared-To-Be-Lonely_Electronic",
        "song-9_album-7_Something-Just-Like-This_Electronic"
    ]
    .compactMap { filename in

        let parts = filename.components(separatedBy: "_")

        guard parts.count == 4 else {
            return nil
        }

        return Song(
            audioFile: filename,
            albumImage: parts[1],
            title: parts[2].replacingOccurrences(of: "-", with: " "),
            genre: parts[3]
        )
    }
}

extension SongLibrary {
    static var randomSong: Song {
        songs.randomElement()!
    }
}
