//
//  LessonsApp.swift
//  Lessons
//
//  Created by iMac on 07/03/23.
//

import SwiftUI

@main
struct LessonsApp: App {
    
    @ObservedObject var lessonsViewModel = LessonsViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(lessonsViewModel)
                .environment(\.colorScheme, .light)
        }
    }
}
