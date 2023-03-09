//
//  LessonsRow.swift
//  Lessons
//
//  Created by iMac on 03/03/23.
//

import SwiftUI

struct LessonsRow: View {
    
    let lesson: Lessons
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 15) {
                let imageClipShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
                AsyncImage(url: lesson.thumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .imageScale(.large)
                            Spacer()
                        }
                    @unknown default:
                        fatalError()
                    }
                }
                .frame(width: 120, height: 70)
                .clipShape(imageClipShape)
                .overlay(imageClipShape.strokeBorder(.quaternary, lineWidth: 0.5))
                .accessibility(hidden: true)
                
                VStack(spacing: 10) {
                    HStack {
                        Text(lesson.name)
                            .font(Font.system(size: 18))
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 20)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.blue)
                            .padding(.trailing, 30)
                    }
                }
            }
            HStack(alignment: .center, spacing: 120) {
                Rectangle()
                    .fill()
                    .padding(.leading, 135)
                    .foregroundColor(.gray.opacity(0.75))
                    .frame(height: 0.5, alignment: .bottom)
            }
        }
    }
}
