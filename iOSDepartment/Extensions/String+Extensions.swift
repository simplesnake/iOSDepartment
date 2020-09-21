//
//  String+Extensions.swift
//  iOSDepartment
//
//  Created by Александр Строев on 08.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation

extension String {
    subscript (_ i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (_ bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start ..< end]) as String
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = [], offsetBy: Int = 0) -> Index? {
        guard let index = range(of: string, options: options)?.lowerBound else {
            return nil
        }
        return self.index(index, offsetBy: offsetBy)
    }
    
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = [], offsetBy: Int = 0) -> Index? {
        guard let index = range(of: string, options: options)?.upperBound else {
            return nil
        }
        return self.index(index, offsetBy: offsetBy)
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
    
}

extension String{
    func toDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toNsDictionary(options: JSONSerialization.ReadingOptions = []) -> NSDictionary? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: options) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toArray(options: JSONSerialization.ReadingOptions = []) -> Array<NSDictionary>? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Array<NSDictionary>
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //capitalize first letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
    
    var data: Data? {
        return self.data(using: .utf8)
    }
    
    func decode<T: Decodable>() -> T? {
        guard let data = data else { return nil }
        let resp: T? = try? JSONDecoder().decode(T.self, from: data)
        return resp
    }
    
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localize(_ table: String = "") -> String {
        return NSLocalizedString(self, tableName: table, comment: "")
    }
    
    func url(prefix: String = "", postfix: String = "") -> URL? {
        return URL(string: "\(prefix)\(self)\(postfix)")
    }
    
    var url: URL? {
        return url()
    }

}
