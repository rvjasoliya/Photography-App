//
//  DataStore.swift
//  Lessons
//
//  Created by iMac on 06/03/23.
//

import Foundation

protocol DataStore: Actor {
    
    associatedtype D
    
    func save(_ current: D)
    func load() -> D?
    
}

actor PlistDataStore<T: Codable>: DataStore where T: Equatable {
    
    private var saved: T?
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    private var dataURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(filename).plist")
    }
    
    func save(_ current: T) {
        if let saved = self.saved, saved == current {
            return
        }
        
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            print("save Data In Local: ", dataURL)
            let data = try encoder.encode(current)
            try data.write(to: dataURL, options: [.atomic])
            self.saved = current
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func load() -> T? {
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            let current = try decoder.decode(T.self, from: data)
            self.saved = current
            return current
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
