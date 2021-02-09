//
//  StringExtensions.swift
//  toDus-SwiftUI
//
//  Created by Wilder Lopez on 8/13/20.
//  Copyright © 2020 iGhost. All rights reserved.
//

import Foundation

extension String {
    static func generateString(lenght: Int = 150) -> String {
        
        let letters : NSString  = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< lenght {
            let random = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(random))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
   static func timeString(time:TimeInterval) -> String {
        //        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }

    /**
     Extension that return the short JID: `55139298@todus.im.todus.cu/90a98sd0as98f0s` will returns  `55139298@todus.im.todus.cu` only.
     
     */
    func shortJID() -> String{
        var str = ""
        var f = true
        self.forEach { (c) in
            if c != "/" && f{
                str.append(c)
            }else {
                f = false
            }
        }
    return str
    }
    
    /**
     Return the first part of the string splited by @.
     
     Convert the JID in ID:
     `55139298@im.todus.cu` ---->  `55139298`
     */
    func clearID(withoutCode: Bool = false) -> String{
        let str = self.split(separator: "@")
        let newStr = str[0]
        if withoutCode && newStr.count == 10{
            return String(newStr.dropFirst(2))
        }
        return str.count >= 2 ? String(str[0]) : self
    }
    
    var condensedWhitespace: String {
            let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
            return components.filter { !$0.isEmpty }.joined(separator: " ")
        }

        func removeSpecialCharacters() -> String {
            let okayChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 ")
            return String(self.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
        }
    
    func trimmedString() -> String{
        return self.trimmingCharacters(in: .whitespaces)
    }

    func fromBase64() -> String? {
           guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
               return nil
           }

           return String(data: data as Data, encoding: String.Encoding.utf8)
    }

    func toBase64() -> String? {
           guard let data = self.data(using: String.Encoding.utf8) else {
               return nil
           }

           return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
           }
}
