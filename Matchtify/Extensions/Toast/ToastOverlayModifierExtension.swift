//
//  ToastOverlayModifierExtension.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

extension View {

    func toastOverlay(
        _ toastManager: ToastManager
    ) -> some View {

        modifier(
            ToastOverlayModifier(
                toastManager: toastManager
            )
        )
    }
}
