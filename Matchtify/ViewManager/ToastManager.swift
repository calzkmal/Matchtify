//
//  ToastManager.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

@Observable
final class ToastManager {

    var message: String?
    var isVisible = false

    func show(_ text: String) {

        message = text

        withAnimation(.spring(duration: 0.4)) {
            isVisible = true
        }

        Task {
            try? await Task.sleep(for: .seconds(2))

            await MainActor.run {
                withAnimation(.spring(duration: 0.4)) {
                    self.isVisible = false
                }
            }
        }
    }
}
