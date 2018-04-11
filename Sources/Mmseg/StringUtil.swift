//
//  StringUtil.swift
//  ILDMmseg
//
//  Created by 张 家豪 on 2017/12/12.
//  Copyright © 2017年 张 家豪. All rights reserved.
//

import Foundation

class StringUtil {
    // MARK: Properties
    
    static var chineseNumbers: [Character]?
    
    static var quantifier: [Character]?
    
    static var punctuation: [Character]?
    
    // MARK: Public Methods
    
    static func isChinese(character: Character) -> Bool {
        if ("\u{4E00}" <= character  && character <= "\u{9FA5}") {
            return true
        }
        return false
    }
    
    static func isNumber(character: Character) -> Bool {
        guard let chineseNumbers = StringUtil.chineseNumbers else {
            fatalError("StringUtil.chineseNumbers Might Not Been Initialized")
        }
        // 0..<9
        if let _ = Int(String(character)) {
            return true
        }
        // chinese
        if chineseNumbers.contains(character) {
            return true
        }
        return false
    }
    
    static func isNumber(string: String) -> Bool {
        for c in string {
            if !isNumber(character: c) && c != "." && c != "点" {
                return false
            }
        }
        return true
    }
    
    static func isQuantifier(character: Character) -> Bool {
        guard let quantifier = StringUtil.quantifier else {
            fatalError("StringUtil.quantifier Might Not Been Initialized")
        }
        return quantifier.contains(character)
    }
    
    static func isPunctuation(character: Character) -> Bool {
        guard let punctuation = StringUtil.punctuation else {
            fatalError("StringUtil.punctuation Might Not Been Initialized")
        }
        return punctuation.contains(character)
    }
}
