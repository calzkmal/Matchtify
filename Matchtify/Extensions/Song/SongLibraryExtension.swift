//
//  SongLibraryExtension.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

extension SongLibrary {
    static var randomSong: Song {
        guard let song = songs.randomElement() else {
            fatalError("No songs found in SongLibrary")
        }

        return song
    }
}
