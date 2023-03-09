//
//  LessonsViewModel.swift
//  Lessons
//
//  Created by iMac on 03/03/23.
//

import Foundation
import Combine

class LessonsViewModel: ObservableObject {
    
    @Published var lessons: [Lessons] = []
    private var disposables = Set<AnyCancellable>()
    static let shared = LessonsViewModel()
    private let lessonsAPI = LessonsAPI.shared
    private let lessonsStore = PlistDataStore<[Lessons]>(filename: "lessons")
    
    init() {
        Task {
            if let lessons = await load() {
                print("Local Data Fetch Successfully ")
                self.lessons = lessons
            }
            fetchLessons()
        }
    }
    
    func fetchLessons() {
        lessonsAPI.fetchLessons()
            .receive(on: DispatchQueue.main)
            .sink { print ("Received completion: \($0).")
            } receiveValue: { data in
                print ("Received Lessons Data: \(data.lessons[0]).")
                for lesson in data.lessons {
                    if !self.isLessons(for: lesson) {
                        self.addLessons(for: lesson)
                    }
                }
            }
            .store(in: &disposables)
        
    }
    
    func restoreAll() {
        fetchLessons()
    }
    
    private func load() async -> [Lessons]?  {
        let lessons = await lessonsStore.load()
        return lessons
    }
    
    func isLessons(for lesson: Lessons) -> Bool {
        lessons.first { lesson.id == $0.id } != nil
    }
    
    func addLessons(for lesson: Lessons) {
        var lessonData = lesson
        if checkFileExists(urlString: lessonData.video_url) {
            lessonData.isVideoDownload = true
        } else {
            lessonData.isVideoDownload = false
        }
        lessons.insert(lessonData, at: 0)
        lessonsUpdated()
    }
    
    func removeLessons(for lesson: Lessons) {
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return
        }
        lessons.remove(at: index)
        lessonsUpdated()
    }
    
    private func lessonsUpdated() {
        let lessons = self.lessons
        Task {
            await lessonsStore.save(lessons)
        }
    }
    
    func checkFileExists(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent(url.lastPathComponent)
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}
