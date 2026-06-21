//
//  AlbumRowComponent.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct AlbumRowComponent: View {

    let assets: [String]
    let alignment: Alignment

    var body: some View {
        HStack(spacing: 16) {

            ForEach(assets, id: \.self) { asset in
                Image(asset)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 104, height: 104)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 4)
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}
