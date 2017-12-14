//
//  main.swift
//  ILDMmseg
//
//  Created by 张 家豪 on 2017/12/4.
//  Copyright © 2017年 张 家豪. All rights reserved.
//
import Foundation
print("Hello, World!")

var wordsManager = WordsManager()

let start1 = CFAbsoluteTimeGetCurrent()
wordsManager.loadWords(from: "Words.txt")
print(String(CFAbsoluteTimeGetCurrent()-start1)+" seconds")

let start2 = CFAbsoluteTimeGetCurrent()
print(wordsManager.matchedStrings(sentence: Substring("工信处女干事阿萨德佛山了单个阿萨")))
print(String(CFAbsoluteTimeGetCurrent()-start2)+" seconds")

let start3 = CFAbsoluteTimeGetCurrent()
print(wordsManager.matchedStrings(sentence: "今天天气不错哦"))
print(String(CFAbsoluteTimeGetCurrent()-start3)+" seconds")

let start4 = CFAbsoluteTimeGetCurrent()
wordsManager.loadCharacter(from: "Chars.txt")
print(String(CFAbsoluteTimeGetCurrent()-start4)+" seconds")

let start5 = CFAbsoluteTimeGetCurrent()
print(wordsManager.characterValue(character: "逛"))
print(String(CFAbsoluteTimeGetCurrent()-start5)+" seconds")

Mmseg.sharedInstance.set(wordsManager: wordsManager)

let start6 = CFAbsoluteTimeGetCurrent()
let sentence = "工信处女干事每月经过下属科室都要亲口交代24口交换机等技术性器件的安装工作"
print(Mmseg.sharedInstance.segment(sentence: sentence, depth: 3))
print(String(CFAbsoluteTimeGetCurrent()-start6)+" seconds")

