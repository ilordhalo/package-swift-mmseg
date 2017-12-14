//
//  StringUtil.swift
//  ILDMmseg
//
//  Created by 张 家豪 on 2017/12/12.
//  Copyright © 2017年 张 家豪. All rights reserved.
//

import Foundation

class StringUtil {
    // MARK: Public Methods
    
    static func isChinese(character: Character) -> Bool {
        if ("\u{4E00}" <= character  && character <= "\u{9FA5}") {
            return true
        }
        return false
    }
}
