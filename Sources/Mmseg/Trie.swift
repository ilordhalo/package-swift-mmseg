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
    
    private var numberNode: Node!
    
    private var otherNode: Node!
    
    // MARK: Initialization
    
    init() {
        root = Node(value: "R")
        otherNode = Node(value: "O")
    }
    
    // MARK: Public Methods
    
    func initNumberNode(quantifier: [Character]) {
        numberNode = Node(value: "N")
        for element in quantifier {
            let newNode = Node(value: element)
            newNode.isEnd = true
            numberNode.children[element] = newNode
        }
    }
    
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
        for c in sentence {
            if let child = node.children[c] {
                prefix += String(c)
                node = child
                if node.isEnd {
                    response.append(prefix)
                }
            }
            else if StringUtil.isNumber(character: c) {
                // !StringUtil.isNumber(character: node.value)
                // 表示如果先前匹配的是数字仍可进入
                if (node.value != otherNode.value && node.value != numberNode.value) && node.value != root.value && !StringUtil.isNumber(character: node.value) {
                    break
                }
                // 不是连续的数字时视为新词，如:n123中n视为一个词
                if node.value == otherNode.value {
                    response.append(prefix)
                }
                prefix += String(c)
                node = numberNode
            }
            else if !StringUtil.isChinese(character: c) {
                if (node.value != otherNode.value && node.value != numberNode.value) && node.value != root.value {
                    break
                }
                // 不是连续的特殊字符时视为新词，如:1+1=2中1视为一词
                if node.value == numberNode.value {
                    response.append(prefix)
                }
                prefix += String(c)
                node = otherNode
            }
            // 避免匹配数字匹配到一半后中断，而跳过量词匹配
            else if let child = numberNode.children[c] {
                if StringUtil.isNumber(character: node.value) {
                    prefix += String(c)
                    node = child
                    if node.isEnd {
                        response.append(prefix)
                    }
                }
            }
            else {
                break
            }
        }
        response.append(prefix)
        return response
    }
}


