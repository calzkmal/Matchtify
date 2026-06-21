//
//  ProfileSheetView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

struct ProfileSheetView: View {

    @Environment(\.dismiss) private var dismiss
    
    // Toast
    @State private var toastManager = ToastManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Button {
                    toastManager.show("Account")
                } label: {
                    HStack(spacing: 16) {

                        Image("ProfilePicture")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text("Calzy Indyramdhani")
                                .font(.headline)
                                .foregroundStyle(Color.primary)

                            Text("Account info, payments, and settings")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.secondary)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                VStack{
                    Button {
                        toastManager.show("Set up profile")
                    } label: {
                        HStack(spacing: 16) {
                            
                            VStack(alignment: .leading) {
                                Text("Set up profile")
                                    .font(.headline)
                                    .foregroundStyle(Color.indigo)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 12)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Text("Set up your profile to share your music and see what your friends are playing.")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .toastOverlay(toastManager)
        .presentationDetents([.large])
        .presentationCornerRadius(40)
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    ProfileSheetView()
}
