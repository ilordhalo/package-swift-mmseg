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
    
    private class Node {
        var value: Character
        var children = [Character: Node]()
        var isEnd: Bool
        init(value: Character) {
            self.value = value
            self.isEnd = false
        }
    }
    
    // MARK: Properties
    
    private var root: Node!
    
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
    
    func matchAll(sentence: Substring) -> [Substring] {
        var response = [Substring]()
        var prefix = Substring()
        var node = root!
        guard let firstCharacter = sentence.first else {
            return response
        }
        // 量词匹配
        if StringUtil.isNumber(character: firstCharacter) {
            for c in sentence {
                if StringUtil.isNumber(character: c) {
                    prefix.append(c)
                }
                else if StringUtil.isQuantifier(character: c) {
                    prefix.append(c)
                    response.append(prefix)
                    prefix = ""
                    break
                }
                else {
                    response.append(prefix)
                    prefix = ""
                    break
                }
            }
        }
        if StringUtil.isChinese(character: firstCharacter) {
            // 词典匹配
            for c in sentence {
                Mmseg.sharedInstance.tag += 1
                if let child = node.children[c] {
                    //prefix += String(c)
                    prefix.append(c)
                    node = child
                    if node.isEnd {
                        response.append(prefix)
                    }
                }
                else {
                    break
                }
            }
        }
        else {
            // 中文标点匹配
            if StringUtil.isPunctuation(character: firstCharacter) {
                prefix.append(firstCharacter)
                response.append(prefix)
                return response
            }
            // 进行特殊符号匹配
            for c in sentence {
                if !StringUtil.isChinese(character: c) && !StringUtil.isPunctuation(character: c) {
                    prefix.append(c)
                }
                else {
                    response.append(prefix)
                    break
                }
            }
        }
        return response
    }
}


