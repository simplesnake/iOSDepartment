//
//  PlistManager.swift
//  iOSDepartment
//
//  Created by Александр Строев on 20.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation

class PlistManager<T: Decodable> {
    
    private var plistData: Data {
        let url = Bundle.main.url(forResource: "iOSDepartment/info", withExtension: "plist")!
        return try! Data(contentsOf: url)
    }
    
    var value: T {
        return try! PropertyListDecoder().decode(T.self, from: plistData)
    }
}

struct BaseURL: Decodable {
    private enum CodingKeys: String, CodingKey {
        case value = "BASE_URL"
    }

    let value: String
    
    var url: URL {
        return value.url!
    }
}
