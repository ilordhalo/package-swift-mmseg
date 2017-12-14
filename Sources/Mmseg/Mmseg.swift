//
//  Mmseg.swift
//  ILDMmseg
//
//  Created by 张 家豪 on 2017/12/5.
//  Copyright © 2017年 张 家豪. All rights reserved.
//

import Foundation

class Mmseg {
    // MARK: Types
    
    class Chunk {
        var words = [Substring]()
        var length: Int = 0
        var averageLength: Float = 0.0
        var variance: Float = 0.0
        var degree: Float = 0.0
        
        init(words: [Substring]) {
            self.words = words
            evaluate()
        }
        
        func firstWord() -> String {
            return String(words[0])
        }
        
        func description() -> String {
            var description = ""
            for word in words {
                description += String(word) + " "
            }
            description += "(" + String(length) + ","
            description += String(averageLength) + ","
            description += String(variance) + ","
            description += String(degree) + ")"
            return description
        }
        
        private func evaluate() {
            guard let wordsManager = Mmseg.wordsManager else {
                fatalError("WordsManager Has Not Been Initialized")
            }
            let wordsLengthF = Float(words.count)
            for word in words {
                let len = word.count
                length += len
                if len == 1 {
                    degree += log(Float(wordsManager.characterValue(character: Character(String(word)))))
                }
            }
            averageLength = Float(length) / wordsLengthF
            for word in words {
                let lenF = Float(word.count)
                variance += powf((lenF - averageLength), 2.0)
            }
            variance /= wordsLengthF
            variance = -variance
        }
    }
    
    // MARK: Properties
    
    static let sharedInstance = Mmseg()
    
    static private var wordsManager: WordsManager?
    
    private var sentence: String?
    
    // MARK: Initialization
    
    private init() {
    }
    
    func load(wordsPath: String, charactersPath: String) {
        Mmseg.wordsManager = WordsManager()
        Mmseg.wordsManager?.loadWords(from: wordsPath)
        Mmseg.wordsManager?.loadCharacter(from: charactersPath)
    }
    
    func set(wordsManager: WordsManager) {
        Mmseg.wordsManager = wordsManager
    }
    
    // MARK: Public Methods
    
    func segment(sentence: String, depth: Int) -> [String] {
        var words = [String]()
        self.sentence = sentence
        var start = sentence.startIndex
        let end = sentence.endIndex
        while start != end {
            let chunks = getChunks(start: start, end: end, depth: depth)
            guard let bestChunk = chunks.max(by: {
                x, y in
                return (x.length, x.averageLength, x.variance, x.degree) < (y.length, y.averageLength, y.variance, y.degree)
            }) else {
                break
            }
            let word = bestChunk.firstWord()
            words.append(word)
            start = sentence.index(start, offsetBy: word.count)
        }
        return words
    }
    
    // MARK: Private Methods
    
    private func getChunks(start: Substring.Index, end: Substring.Index, depth: Int) -> [Chunk] {
        guard let wordsManager = Mmseg.wordsManager else {
            fatalError("WordsManager Has Not Been Initialized")
        }
        guard let sentence = sentence else {
            fatalError("Sentence Has Not Been Set")
        }
        var chunks = [Chunk]()
        func getChunksSubstring(start: Substring.Index, end: Substring.Index, depth: Int, segs: [Substring]) {
            if depth == 0 || start == end {
                chunks.append(Chunk(words: segs))
                return
            }
            let matchedWords = wordsManager.matchedStrings(sentence: sentence[start..<end])
            for word in matchedWords {
                var newSegs = segs
                newSegs.append(Substring(word))
                getChunksSubstring(start: sentence.index(start, offsetBy: word.count), end: end, depth: depth - 1, segs: newSegs)
            }
            let nextStart = sentence.index(after: start)
            var newSegs = segs
            newSegs.append(sentence[start..<nextStart])
            getChunksSubstring(start: nextStart, end: end, depth: depth - 1, segs: newSegs)
        }
        getChunksSubstring(start: start, end: end, depth: depth, segs: [Substring]())
        return chunks
    }
}
