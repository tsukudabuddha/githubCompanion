//
//  Event.swift
//  githubCompanion
//
//  Created by Andrew Tsukuda on 11/7/17.
//  Copyright © 2017 Andrew Tsukuda. All rights reserved.
//

import Foundation


struct Event {
    let type: String?
    let date: String?
    
    init(type: String, date: String) {
        self.type = type
        self.date = date
    }
}

extension Event: Decodable {
    
    enum Keys: String, CodingKey {
        case type
        case date = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        // Define container
        let container = try decoder.container(keyedBy: Keys.self)
        
        let type = try container.decodeIfPresent(String.self, forKey: .type) ?? "broken? type?"
        let date = try container.decodeIfPresent(String.self, forKey: .date) ?? "07/17/1998 lit"
        
        self.init(type: type, date: date)
    }
}
