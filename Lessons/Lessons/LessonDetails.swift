//
//  LessonDetails.swift
//  Lessons
//
//  Created by iMac on 03/03/23.
//

import SwiftUI
import AVKit

struct LessonDetails: View {
    
    @StateObject var network = Network()
    @ObservedObject var lessonsViewModel: LessonsViewModel
    @State private var isPresented = false
    @State var selectedIndexPath: Int = 0 {
        didSet {
            self.lastIndex()
        }
    }
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var isLastIndex: Bool = false
    @State private var showAlertSheet = false
    
    @State var dataTask: URLSessionDataTask?
    let destinationUrl: URL
    @State var observation: NSKeyValueObservation?
    
    @State var progressView = CircularProgressView()
    
    var body: some View {
        VStack(alignment: .leading) {
            VideoPlayer(player: AVPlayer(url: (lessonsViewModel.lessons[selectedIndexPath].isVideoDownload ?? false) ? destinationUrl : URL(string: lessonsViewModel.lessons[selectedIndexPath].video_url)!))
                .fullScreenCover(isPresented: $isPresented, onDismiss: nil, content: {
                    PlayerViewController(videoURL: (lessonsViewModel.lessons[selectedIndexPath].isVideoDownload ?? false) ? destinationUrl : URL(string: lessonsViewModel.lessons[selectedIndexPath].video_url)!)
                        .edgesIgnoringSafeArea(.bottom)
                })
                .onTapGesture {
                    if (lessonsViewModel.lessons[selectedIndexPath].isVideoDownload ?? false) {
                        self.isPresented.toggle()
                    } else {
                        if !network.connected {
                            showAlertSheet = true
                        } else {
                            self.isPresented.toggle()
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 0.275))
            
            Text(lessonsViewModel.lessons[selectedIndexPath].name)
                .foregroundColor(.white)
                .font(Font.system(size: 30, weight: .bold, design: .rounded))
                .padding([.trailing,.leading], 12.0)
                .padding([.bottom], 10.0)
            Text(lessonsViewModel.lessons[selectedIndexPath].description)
                .foregroundColor(.white)
                .font(Font.system(size: 20, weight: .regular, design: .rounded))
                .padding([.trailing,.leading], 12.0)
            HStack {
                Spacer()
                if !isLastIndex {
                    Button {
                        print("About tapped!")
                        self.selectedIndexPath += 1
                    } label: {
                        HStack {
                            Text("Next Lesson")
                                .font(Font.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                            Image(systemName: "chevron.right")
                                .font(Font.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                                .padding(.trailing, 30)
                        }
                    }.padding([.top], 20)
                }
            }
            Spacer()
        }
        .onAppear(perform: {
            URLSession.shared.getTasksWithCompletionHandler { urlSessionDataTask, urlSessionUploadTask, urlSessionDownloadTask in
                for task in urlSessionDataTask {
                    if task.taskIdentifier == lessonsViewModel.lessons[selectedIndexPath].taskIdentifier {
                        self.dataTask = task
                        progressView.dataTask = self.dataTask
                        progressView.refreshProgress()
                    }
                    print("task.taskIdentifier", task.taskIdentifier)
                }
            }
            checkFileExists()
        })
        .background(Color.black.opacity(0.9))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button {
            if (lessonsViewModel.lessons[selectedIndexPath].isVideoDownload ?? false) == true {
                return
            } else {
                if !network.connected {
                    showAlertSheet = true
                } else {
                    if (lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading ?? false) {
                        self.dataTask?.suspend()
                        self.dataTask?.cancel()
                        self.dataTask = nil
                        DispatchQueue.main.async {
                            lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = false
                        }
                    } else {
                        downloadFile()
                    }
                }
            }
        } label: {
            HStack {
                if (lessonsViewModel.lessons[selectedIndexPath].isVideoDownload ?? false) {
                    Text("Downloaded")
                        .font(.headline)
                        .foregroundColor(.blue)
                } else {
                    if (lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading ?? false) {
                        CircularProgressView(dataTask: self.dataTask)
                            .frame(width: 20, height: 20)
//                        progressView
//                            .frame(width: 20, height: 20)
//                            .task {
//                                progressView.dataTask = self.dataTask
//                                progressView.refreshProgress()
//                            }
                    } else {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    Text((lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading ?? false) ? "Cancel" : "Download")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }.accessibilityIdentifier("Download Button"))
        .alert("Please Connected to the internet", isPresented: $showAlertSheet, actions: {
            Button("OK", role: .cancel) {
                showAlertSheet = false
            }
        })
        .task {
            print(UIDevice.current.orientation.isLandscape ? "true" : false)
        }
        .onRotate { newOrientation in
            orientation = newOrientation
            if orientation.isLandscape {
                print("orientation.isLandscape")
                self.isPresented.toggle()
            }
        }
        
    }
    
    func lastIndex() {
        print(selectedIndexPath)
        if self.selectedIndexPath == (self.lessonsViewModel.lessons.count - 1) {
            self.isLastIndex = true
        } else {
            self.isLastIndex = false
        }
        print(isLastIndex)
    }
    
}

extension LessonDetails {
    
    func downloadFile() {
        print("Video Download Start")
        lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = true
        guard let url = URL(string: lessonsViewModel.lessons[selectedIndexPath].video_url) else {
            return
        }
        print("Video Url", url.absoluteString)
        if (FileManager().fileExists(atPath: destinationUrl.path)) {
            print("File already exists")
            lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = false
            lessonsViewModel.lessons[selectedIndexPath].isVideoDownload = true
        } else {
            DispatchQueue.global().async {
                let urlRequest = URLRequest(url: url)
                
                self.dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    
                    if let error = error {
                        print("Request error: ", error)
                        DispatchQueue.main.async {
                            lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = false
                        }
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    
                    if response.statusCode == 200 {
                        guard let data = data else {
                            DispatchQueue.main.async {
                                lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = false
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = false
                                lessonsViewModel.lessons[selectedIndexPath].isVideoDownload = true
                            } catch let error {
                                print("Error decoding: ", error)
                                lessonsViewModel.lessons[selectedIndexPath].isVideoDownloading = false
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.lessonsViewModel.lessons[selectedIndexPath].taskIdentifier = self.dataTask?.taskIdentifier
                    print("task.taskIdentifier", self.dataTask?.taskIdentifier ?? 0 )
                }
                progressView.dataTask = self.dataTask
                progressView.refreshProgress()
                self.dataTask?.resume()
            }
        }
    }
    
    private func reset() {
        observation?.invalidate()
        
        dataTask?.cancel()
        lessonsViewModel.lessons[selectedIndexPath].progress = 0
    }
    
    func checkFileExists() {
        print(destinationUrl.path)
        if (FileManager().fileExists(atPath: destinationUrl.path)) {
            lessonsViewModel.lessons[selectedIndexPath].isVideoDownload = true
        } else {
            lessonsViewModel.lessons[selectedIndexPath].isVideoDownload = false
        }
    }
}

