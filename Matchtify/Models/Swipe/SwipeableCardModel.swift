//
//  SwipeableCardModel.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import Foundation

struct SwipeableCardModel: Identifiable, Equatable {
    let id = UUID()
    let song: Song
    var swipeDirection: SwipeDirection = .none
}
