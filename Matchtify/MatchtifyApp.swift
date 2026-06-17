//
//  MatchtifyApp.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

@main
struct MatchtifyApp: App {
    
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MatchSong()
            } else {
                SplashScreen()
            }
        }
    }
}
