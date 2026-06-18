//
//  SongLibrary.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 18/06/26.
//

import Foundation

struct SongLibrary {

    static var songs: [Song] {

        guard let resourcePath = Bundle.main.resourcePath else {
            return []
        }

        let files = (try? FileManager.default.contentsOfDirectory(
            atPath: resourcePath
        )) ?? []

        return files
            .filter {
                $0.hasSuffix(".mp3")
            }
            .compactMap { file in

                let filename = file.replacingOccurrences(
                    of: ".mp3",
                    with: ""
                )

                let parts = filename.components(
                    separatedBy: "_"
                )

                guard parts.count == 5 else {
                    return nil
                }

                return Song(
                    audioFile: filename,
                    albumImage: parts[1],
                    title: parts[2].replacingOccurrences(of: "-", with: " "),
                    artist: parts[3].replacingOccurrences(of: "-", with: " "),
                    genre: parts[4]
                )
            }
    }
}

extension SongLibrary {
    static var randomSong: Song {
        songs.randomElement()!
    }
}
