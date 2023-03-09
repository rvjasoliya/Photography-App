//
//  LessonsAPI.swift
//  Lessons
//
//  Created by iMac on 03/03/23.
//

import Foundation
import Combine

struct LessonsAPI {
    
    static let shared = LessonsAPI()
    private let apiUrl = "https://iphonephotographyschool.com/test-api/lessons"
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private var session = URLSession.shared
    
    private init() {
        
    }
    
    func fetchLessons() -> AnyPublisher<LessonsAPIResponse, Error> {
        return session.dataTaskPublisher(for: URL(string: apiUrl)!)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            })
            .decode(type: LessonsAPIResponse.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
}
