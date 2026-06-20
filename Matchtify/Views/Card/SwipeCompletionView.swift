//
//  SwipeCompletionView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI

struct SwipeCompletionView: View {

    @ObservedObject
    var model: SwipeableCardsModel

    var action: (SwipeableCardsModel) -> Void

    var body: some View {

        VStack(spacing: 20) {

            Text("Finished Swiping")
                .font(.title)

            Button {

                action(model)

            } label: {

                Text("Reset")
                    .font(.headline)
                    .frame(
                        width: 200,
                        height: 50
                    )
                    .background(
                        Color.accentColor
                    )
                    .foregroundStyle(
                        .white
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
            }
        }
    }
}
