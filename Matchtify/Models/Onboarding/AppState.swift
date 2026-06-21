//
//  AppState.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import Foundation
import Observation

enum AppScreen {
    case splash
    case onboarding
    case main
}

@Observable
final class AppState {

    var screen: AppScreen
    var currentStep = 1

    init() {

        let hasCompletedOnboarding =
            UserDefaults.standard.bool(
                forKey: "hasCompletedOnboarding"
            )

        screen =
            hasCompletedOnboarding
            ? .main
            : .splash
    }

    func finishOnboarding() {

        UserDefaults.standard.set(
            true,
            forKey: "hasCompletedOnboarding"
        )

        currentStep = 1
        screen = .main
    }

    func resetOnboarding() {

        UserDefaults.standard.set(
            false,
            forKey: "hasCompletedOnboarding"
        )

        currentStep = 1
        screen = .splash
    }
}
