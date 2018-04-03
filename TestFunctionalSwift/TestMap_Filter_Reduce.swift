//
//  TestMap_Filter_Reduce.swift
//  TestFunctionalSwift
//
//  Created by MarisLin on 2018/4/3.
//  Copyright © 2018年 LinMaris. All rights reserved.
//

import UIKit

class TestMap_Filter_Reduce: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        testMap()

//        testFlatMap()

//        testFilter()

//        testReduce()
        
        // 计算一个二维Int数组的元素之和
        sumInt()
        
        //
        print("实现map:", increment2(array: [1,2,3]))
        
        // 思考: 泛型 和 Any的区别是什么
        // 1. 泛型可以用于定义灵活的函数, 类型检查依然由编译器负责, Any类型会避开Swift的类型系统, 就是Any类型
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TestMap_Filter_Reduce {
    
    // 用在SequenceType (数组, 字典等), 也可用于Optionals (String等)
    // map: 遍历元素, 对每个元素进行操作, 返回一个新的序列
    func testMap() {
        let values = [1, 2, 3, 4]
        let result = values.map { (element) -> Int in
            return element * 2
        }
        // 精简写法
        let result2 = values.map({ $0 * 2 })
        let result3 = values.map_lc({ $0 * 3 })
        let result4 = values.mapUsingReduce({ $0 * 4})
        print("map:", result, result2, result3, result4)  // [2, 4, 6, 8]
    }
    
    // flatMap: 降一维, 过滤nil
    func testFlatMap() {
        let values = [[1, 2, 3], [4, 5, 6]]
        let values2 = [[["a", "b", "c"],["d", "e", "f"],["g", "h", "i"]],
                       [["j", "k", "m"],["l", "n", "o"],["p", "q", "r"]]]
        // 精简写法
        let result = values2.flatMap({ $0 })
        let result2 = result.flatMap({$0})
        print("flatMap:", result, result2)
    }
    
    // filter: 过滤掉不符合条件的值
    func testFilter() {
        let values = [1,2,3,4,5]
        let result = values.filter { (element) -> Bool in
            return element % 2 == 0
        }
        // 精简写法
        let result2 = values.filter({ $0 % 2 == 0})
        let result3 = values.filter_lc({ $0 % 3 == 0})
        let result4 = values.filterUsingReduce({ $0 % 4 == 0})
        print("filter:", result, result2, result3, result4)  // [2, 4]
    }
    
    // reduce: 处理序列中相邻的两个值
    func testReduce() {
        let values = [1, 2, 3]
        let initResult = 0
        let result = values.reduce(initResult) { $0 + $1 }
        let result2 = values.reduce_lc(initResult, combine: +)  // 将 + 作为操作符
        let result3 = values.reduce_lc(initResult) {result,x in result+x}
        print("reduce:", result, result2, result3)
    }
    
    // 面试题: 计算一个二维Int数组的元素之和
    func sumInt() {
        let values = [[1, 2, 3], [1, 2, 3]]
        let result = values.flatMap { $0 }.reduce(0) {$0 + $1}
        print("sumInt:", result)
    }
}

//MARK: 补充
extension TestMap_Filter_Reduce {
    
    // 实现map: 遍历每个元素, 使之加1, 并返回一个序列
    func increment(array: [Int]) -> [Int] {
        var result = [Int]()
        for x in array {
            result.append(x + 1)
        }
        return result
    }
    
    func compute(array: [Int], transform: (Int) -> Int) -> [Int] {
        var result = [Int]()
        for x in array {
            result.append(transform(x))
        }
        return result
    }
    
    // 将 increment 中的代码改造
    func increment2(array: [Int]) -> [Int] {
//        return compute(array: array, transform: { (element) -> Int in
//            return element + 1
//        })
        // 简化
//        return compute(array: array, transform: { $0 + 1})
        
        // 另一种写法,   这三种写法效果一样
        return compute(array: array) { $0 + 1 }
    }
    
    // 想要得到一个布尔型的新数组，用于表示原数组中, 对应的数字是否是偶数。
    // 可以这么做,
    func compute2(array: [Int], transform: (Int) -> Bool) -> [Bool] {
        var result = [Bool]()
        for x in array {
            result.append(transform(x))
        }
        return result
    }
    func isEven(array: [Int]) -> [Bool] {
        return compute2(array: array) { $0 % 2 == 0}
    }
    
    // 通过使用泛型,扩展,        这个其实和 官方的map基本相同
    func genericCompute<Element,T>(array: [Element], transform: (Element) -> T) -> [T] {
        var result = [T]()
        for x in array {
            result.append(transform(x))
        }
        return result
    }
}

//MARK: map filter reduce
extension Array {
    
    // 遍历数组中的每一个元素, 并在闭包中做处理(+1, *2, *3等), 最后返回序列
    func map_lc<T>(_ transform: (Element) -> T) -> [T] {
        var result = [T]()
        for x in self {
            result.append(transform(x))
        }
        return result
    }
    
    // 遍历数组中的每一个元素, 并在闭包中做处理(%2 == 0等), 满足条件则添加到数组中并返回
    func filter_lc(_ includeElement: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        for x in self where includeElement(x) {
            result.append(x)
        }
        return result
    }
    
    // 使用: Int数组中求和,求积, Sting数组中所有元素拼接等
    func reduce_lc<T>(_ initial: T, combine: (T,Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
    
    // 用reduce 重新定义 map
    func mapUsingReduce<T>(_ transform: (Element) -> T) -> [T] {
        return reduce_lc([]) { result, x in
            return result + [transform(x)]
        }
    }
    
    // 用reduce 重新定义 filter
    func filterUsingReduce(_ includeElement: (Element) -> Bool) -> [Element] {
        return reduce_lc([]) { result, x in
            return includeElement(x) ? result + [x]:result
        }
    }
}




