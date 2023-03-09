//
//  ContentView.swift
//  Lessons
//
//  Created by iMac on 07/03/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            LessonsList()
                .navigationTitle("Lessons")
                .background(Color.black.opacity(0.9))
                .foregroundColor(.white)
                .navigationBar(backgroundColor: Color(hex: "1E1E1E"), titleColor: .white)
        }.foregroundColor(Color.black.opacity(0.9))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
