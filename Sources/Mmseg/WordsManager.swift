//
//  WordCollection.swift
//  ILDMmseg
//
//  Created by 张 家豪 on 2017/12/7.
//  Copyright © 2017年 张 家豪. All rights reserved.
//

import Foundation

class WordsManager {
    // MARK: Properties
    
    private var trie: Trie!
    private var characters: [Character: Float]!
    
    // MARK: Initialization
    
    init() {
        trie = Trie()
        characters = [Character: Float]()
    }
    
    // MARK: Public Methods
    
    func loadWords(from path: String) {
        let dataString = getData(from: path)
        for word in dataString.split(separator: "\n") {
            let trimWord = word.trimmingCharacters(in: [" "])
            trie.add(word: trimWord)
        }
    }
    
    func loadCharacter(from path: String) {
        let dataString = getData(from: path)
        for line in dataString.split(separator: "\n") {
            let trimLine = line.trimmingCharacters(in: [" "])
            let section = trimLine.split(separator: " ").map({
                element in
                return String(element)
            })
            characters[Character(section[0])] = Float(section[1])
        }
    }
    
    func loadQuantifier(from path: String) {
        let dataString = getData(from: path)
        StringUtil.quantifier = [Character]()
        for line in dataString.split(separator: "\r\n") {
            let trimLine = line.trimmingCharacters(in: [" "])
            if trimLine.first == "#" {
                continue
            }
            StringUtil.quantifier?.append(Character(trimLine))
        }
    }
    
    func loadChineseNumber(from path: String) {
        let dataString = getData(from: path)
        StringUtil.chineseNumbers = [Character]()
        for line in dataString.split(separator: "\n") {
            let trimLine = line.trimmingCharacters(in: [" "])
            StringUtil.chineseNumbers?.append(Character(trimLine))
        }
    }
    
    func loadPunctuation(from path: String) {
        let dataString = getData(from: path)
        StringUtil.punctuation = [Character]()
        for line in dataString.split(separator: "\n") {
            let trimLine = line.trimmingCharacters(in: [" "])
            guard let character = trimLine.first else {
                fatalError("Unexpected Punctuation Found In '" + trimLine + "'")
            }
            StringUtil.punctuation?.append(character)
        }
    }
    
    func characterValue(character: Character) -> Float {
        guard let value = characters[character] else {
            return 0
        }
        return value
    }
    
    func matchedStrings(sentence: Substring) -> [Substring] {
        return trie.matchAll(sentence: sentence)
    }
    
    // Private Methods
    
    private func getData(from path: String) -> String {
        let fileManager = FileManager.default
        let url = URL.init(fileURLWithPath: path)
        let filePath = url.path
        guard fileManager.fileExists(atPath: filePath) else {
            fatalError("No Such File " + filePath)
        }
        guard let data = fileManager.contents(atPath: filePath) else {
            fatalError("No Data Found In File " + filePath)
        }
        guard let dataString = String.init(data: data, encoding: String.Encoding.utf8) else {
            fatalError("Fail To Convert Data To String")
        }
        return dataString
    }
}


