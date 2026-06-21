//
//  LibraryRowComponent.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

struct LibraryRowComponent: View {
    let title: String
    let icon: String
    
    @State private var toastManager = ToastManager()

    var body: some View {
        Button {
            toastManager.show(title)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundStyle(Color.indigo)
                
                Text(title)
                    .foregroundStyle(Color.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.secondary)
            }
            .padding(.vertical, 16)
        }
        .toastOverlay(toastManager)
    }
}


#Preview {
    LibraryRowComponent(title: "Liked", icon: "safari")
}
