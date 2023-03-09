//
//  LessonsList.swift
//  Lessons
//
//  Created by iMac on 03/03/23.
//

import SwiftUI

struct LessonsList: View {
    
    @EnvironmentObject var lessonsViewModel: LessonsViewModel
    
    var body: some View {
        
        List(lessonsViewModel.lessons.indices, id: \.self) { index in
            ZStack(alignment: .leading) {
                NavigationLink {
                    let url = URL(string: lessonsViewModel.lessons[index].video_url)!
                    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    let destinationUrl = docsUrl?.appendingPathComponent(url.lastPathComponent)
                    LessonDetails(lessonsViewModel: lessonsViewModel, selectedIndexPath: index, destinationUrl: destinationUrl!)
                } label: {
                    EmptyView()
                }
                .opacity(0)
                LessonsRow(lesson: lessonsViewModel.lessons[index])
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .accessibilityHidden(true)
            .listRowBackground(Color.clear)
        }
        .accessibilityIdentifier("lessonsList")
        .listStyle(.plain)
        .refreshable {
            lessonsViewModel.restoreAll()
        }
        
    }
    
}

struct LessonsList_Previews: PreviewProvider {
    static var previews: some View {
        LessonsList()
    }
}
