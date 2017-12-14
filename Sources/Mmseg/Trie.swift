//
//  Trie.swift
//  ILDMmseg
//
//  Created by 张 家豪 on 2017/12/5.
//  Copyright © 2017年 张 家豪. All rights reserved.
//

import Foundation

class Trie {
    // MARK: Types
    
    class Node {
        var value: Character
        var children = [Character: Node]()
        var isEnd: Bool
        init(value: Character) {
            self.value = value
            self.isEnd = false
        }
    }
    
    // MARK: Properties
    
    var root: Node!
    
    // MARK: Initialization
    
    init() {
        root = Node(value: "R")
    }
    
    // MARK: Public Methods
    
    func add(word: String) {
        var node = root!
        for c in word {
            if let child = node.children[c] {
                node = child
                continue
            }
            let newNode = Node(value: c)
            node.children[c] = newNode
            node = newNode
        }
        node.isEnd = true
    }
    
    func match(word: String) -> Bool {
        var node = root!
        for c in word {
            if let child = node.children[c] {
                node = child
                continue
            }
            else {
                return false
            }
        }
        if node.isEnd {
            return true
        }
        return false
    }
    
    func matchAll(sentence: String) -> [String] {
        var response = [String]()
        var prefix = ""
        var node = root!
        guard let firstC = sentence.first else {
            return response
        }
        if !StringUtil.isChinese(character: firstC) {
            for c in sentence {
                if StringUtil.isChinese(character: c) {
                    break
                }
                else {
                    prefix += String(c)
                }
            }
            response.append(prefix)
            return response
        }
        for c in sentence {
            if let child = node.children[c] {
                prefix += String(c)
                node = child
                if node.isEnd {
                    response.append(prefix)
                }
                continue
            }
            else {
                break
            }
        }
        return response
    }
    
    func matchAll(sentence: Substring) -> [Substring] {
        var response = [Substring]()
        var prefix = Substring()
        var node = root!
        guard let firstC = sentence.first else {
            return response
        }
        if !StringUtil.isChinese(character: firstC) {
            for c in sentence {
                if StringUtil.isChinese(character: c) {
                    break
                }
                else {
                    prefix += String(c)
                }
            }
            response.append(prefix)
            return response
        }
        for c in sentence {
            if let child = node.children[c] {
                prefix += String(c)
                node = child
                if node.isEnd {
                    response.append(prefix)
                }
                continue
            }
            else {
                break
            }
        }
        return response
    }
}
