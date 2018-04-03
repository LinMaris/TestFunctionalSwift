//
//  TestDictionaryVC.swift
//  TestFunctionalSwift
//
//  Created by MarisLin on 2018/4/3.
//  Copyright © 2018年 LinMaris. All rights reserved.
//

import UIKit

class TestDictionaryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TestDictionaryVC
{
    func testDic() {
        let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]
        let madrid: Int? = cities["Madrid"]
        // let madrid: Int = cities["Madrid"] 这样写会报错,此时字典中key对应的值编译器还不知道是否有值
        
        if let madrid2 = cities["Madrid"] {  // 可选绑定. 避免使用!强制解包
            print(madrid2)
        }
        
        // Swift 还提供了 ??,设置默认值, 防止因为nil崩溃
    }
    
}
