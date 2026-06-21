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
    
    private let totalSteps = 4

    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    @State private var screen: AppScreen = .splash
    @State private var currentStep = 1

    init() {
        let completedOnboarding = UserDefaults.standard.bool(
            forKey: "hasCompletedOnboarding"
        )
        _screen = State(initialValue: completedOnboarding ? .home : .splash)
    }

    var body: some View {
        Group {
            switch screen {
            case .splash:
                SplashScreen {
                    hasCompletedOnboarding = true
                    currentStep = 1
                    screen = .match
                }
            case .match:
                OnboardingView(
                    currentStep: Binding(
                        get: { currentStep },
                        set: { newValue in
                            if newValue > totalSteps {
                                currentStep = 1
                                screen = .home
                            } else {
                                currentStep = newValue
                            }
                        }
                    ),
                    onNext: {
                        audioManager.nextSong()
                    },
                    onSkip: {
                        currentStep = 1
                        screen = .home
                    }
                )
            case .home:
                MainTabView()
            }
        }
        .environmentObject(audioManager)
    }
}

private enum AppScreen {
    case splash
    case match
    case home
}

#Preview {
    ContentView()
}
