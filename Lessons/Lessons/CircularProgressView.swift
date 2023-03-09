//
//  CircularProgressView.swift
//  Lessons
//
//  Created by iMac on 07/03/23.
//

import SwiftUI

struct CircularProgressView: View {
    
    @State var dataTask: URLSessionDataTask?
    @State var observation: NSKeyValueObservation?
    @State var progress: Double = 0.1
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.blue.opacity(0.5),
                    lineWidth: 3.5
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 3.5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
        .onAppear {
            self.observation = dataTask?.progress.observe(\.fractionCompleted) { observationProgress, _ in
                DispatchQueue.main.async {
                    print("Download Progress: ", String(format: "%.2f", (observationProgress.fractionCompleted * 100)))
                    self.progress = observationProgress.fractionCompleted
                }
            }
        }
    }
    
    func refreshProgress() {
        
    }
    
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.2)
    }
}
