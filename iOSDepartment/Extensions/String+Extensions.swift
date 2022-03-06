//
//  String+Extensions.swift
//  iOSDepartment
//
//  Created by Александр Строев on 08.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

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
    
    var localizeError: String {
        return NSLocalizedString(self, tableName: "ErrorLocalizable", comment: "")
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
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
    func ageCount(count: Int) -> String{
            
        if (count == 0) {
            return "\(count) лет"
        }
            
            if (count % 10 == 1
                &&
                count % 100 != 11) {
                
                return "\(count) год"
            }
            else
                if ((count % 10 >= 2 && count % 10 <= 4)
                    &&
                    !(count % 100 >= 12 && count % 100 <= 14)) {
                    
                    return "\(count) года"
            }
                else
                    if (count % 10 == 0
                        ||
                        (count % 10 >= 5 && count % 10 <= 9)
                        ||
                        (count % 100 >= 11 && count % 100 <= 14)) {
                        
                        return String.init(format: "\(count) лет", count)
            }
            return "\(count) лет";
        }
    
    func monthCount(count: Int) -> String{
            
        if (count == 0) {
            return "\(count) месяцев"
        }
            
            if (count % 10 == 1
                &&
                count % 100 != 11) {
                
                return "\(count) месяц"
            }
            else
                if ((count % 10 >= 2 && count % 10 <= 4)
                    &&
                    !(count % 100 >= 12 && count % 100 <= 14)) {
                    
                    return "\(count) месяца"
            }
                else
                    if (count % 10 == 0
                        ||
                        (count % 10 >= 5 && count % 10 <= 9)
                        ||
                        (count % 100 >= 11 && count % 100 <= 14)) {
                        
                        return String.init(format: "\(count) месяцев", count)
            }
            return "\(count) лет";
        }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
            return ceil(boundingBox.height)
        }

        func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.width)
        }
    
    
    var isValidEmail: Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: self)
        }
    var filePathFromUrl: String {
        let urlString = self
        do {
                let regex = try NSRegularExpression(pattern: "[a-zA-z0-9-]*(.jpeg|.jpg|.png)")
                let results = regex.matches(in: urlString,
                                            range: NSRange(urlString.startIndex..., in: urlString))
                let filename = results.map {
                    String(urlString[Range($0.range, in: urlString)!])
                }
            return filename[0]
        } catch {
            
        }
        return urlString
    }
    
    func toDateFormatted()-> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            return formatter.date(from: self)
    }
    
    var isValidInn: Bool {
        
        
        
        var result = false
        if count == 0 {
            result = false
        }
        if count == 10 {
            let numbers: [Int] = [2, 4, 10, 3, 5, 9, 4, 6, 8, 0]
            var sum: Int = 0
            for i in 0...9 {
                if let number = Int(self[i].lowercased()) {
                    sum += number * numbers[i]
                }
            }
            let contrSum: Int = sum / 11
            let contrCheck = contrSum * 11
            
            if sum - contrCheck == Int((self.last?.lowercased())!) {
                result = true
            }
            
        }
        if count == 12 {
            var numbers: [Int] = [7,2,4,10,3,5,9,4,6,8,0]
            var sum: Int = 0
            for i in 0...10 {
                if let number = Int(self[i].lowercased()) {
                    sum += number * numbers[i]
                }
            }
            var contrNum1: Int = sum / 11
            contrNum1 = sum - contrNum1 * 11
            
            numbers = [3,7,2,4,10,3,5,9,4,6,8,0]
            sum = 0
            for i in 0...11 {
                if let number = Int(self[i].lowercased()) {
                    sum += number * numbers[i]
                }
            }
            var contrNum2: Int = sum / 11
            contrNum2 = sum - contrNum2 * 11
            if let number1 = Int(self[10].lowercased()), let number2 = Int(self[11].lowercased()) {
                if number1 == contrNum1 && number2 == contrNum2 {
                    result = true
                }
            }
        }
        
        return result
    }
    
    var isValidSnils: Bool {
        var snils = filter("0123456789.".contains)
        var result = false
        
        if snils.count == 11 {
            var contrNum: Int = 0
            if let number1 = Int(snils[10].lowercased()), let number2 = Int(snils[9].lowercased()) {
                contrNum = number1 + number2 * 10
                snils.removeLast()
                snils.removeLast()
            }
            var sum = 0
            let numbers = [9,8,7,6,5,4,3,2,1]
            for i in 0...8 {
                if let number = Int(snils[i].lowercased()) {
                    sum += number * numbers[i]
                }
            }
            if sum < 100 {
                if sum == contrNum {
                    result = true
                }
            } else {
                if sum == 100 {
                    if contrNum == 0 {
                        result = true
                    }
                } else {
                    sum = sum % 101
                    if sum == contrNum {
                        result = true
                    }
                }
            }
        }
        
        return result
    }
    
    var containsEmoji: Bool {
            for scalar in unicodeScalars {
                if !scalar.properties.isEmoji { continue }
                return true
            }

            return false
        }

    
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
}
