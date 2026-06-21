//
//  ContentView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager =
        AudioManager(song: SongLibrary.songs[0])
    
    @State private var
    appState = AppState()

    var body: some View {
        Group {
            switch appState.screen {

            case .splash:
                SplashScreen {
                    appState.screen = .onboarding
                }

            case .onboarding:
                OnboardingView(
                    currentStep: Binding(
                        get: {
                            appState.currentStep
                        },
                        set: { newValue in
                            if newValue > OnboardingModel.totalSteps {
                                appState.finishOnboarding()
                            } else {
                                appState.currentStep = newValue
                            }
                        }
                    ),
                    onNext: {
                        audioManager.nextSong()
                    },
                    onSkip: {
                        appState.finishOnboarding()
                    }
                )

            case .main:
                MainTabView()
            }
        }
        .environmentObject(audioManager)
        .environment(appState)
    }
}

#Preview {
    ContentView()
}
