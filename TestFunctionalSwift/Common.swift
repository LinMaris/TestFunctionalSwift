//
//  Common.swift
//  TestFunctionalSwift
//
//  Created by MarisLin on 2018/4/3.
//  Copyright © 2018年 LinMaris. All rights reserved.
//

import UIKit

// 自定义运算符
postfix operator >~

infix operator >>>

prefix operator ~>

// 操作符在左  ~>int
prefix func ~>(v: Int?) -> Int {
    return v == nil ? 0 : v!
}

// 操作符在右  str>~
postfix func >~(v: String?) -> String {
    return v == nil ? "" : v!
}

typealias Filter = (CIImage) -> CIImage

// 操作符在中
func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}

