//
//  ViewController.swift
//  TestFunctionalSwift
//
//  Created by 林川 on 2018/4/2.
//  Copyright © 2018年 LinMaris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testCoreImgVC = TestCoreImageVC()
        view.addSubview(testCoreImgVC.view)
        addChildViewController(testCoreImgVC)
        
        let testMapVC = TestMap_Filter_Reduce()
        view.addSubview(testMapVC.view)
        addChildViewController(testMapVC)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    
}















