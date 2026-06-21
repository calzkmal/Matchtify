//
//  ToastViewModifier.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct ToastOverlayModifier: ViewModifier {

    @Bindable var toastManager: ToastManager

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {

                if toastManager.isVisible,
                   let message = toastManager.message {

                    ToastComponent(message: message)
                        .padding(.bottom, 32)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom)
                                    .combined(with: .scale(scale: 0.9)),
                                removal: .opacity
                            )
                        )
                }
            }
    }
}
