//
//  Toast.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct ToastComponent: View {

    let message: String

    var body: some View {
        Text("Tapped: \(message)")
            .font(.callout)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect()
            .tint(.indigo)
    }
}
