//
//  TestCoreImageVC.swift
//  TestFunctionalSwift
//
//  Created by 林川 on 2018/4/2.
//  Copyright © 2018年 LinMaris. All rights reserved.
//

import UIKit

class TestCoreImageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("testCoreImage")
        
        testAdd()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: 自定义运算符
extension TestCoreImageVC {
    // 高斯模糊滤镜
    func blur(radius: Double) -> Filter {
        return { image in
            let params: [String: Any] = [kCIInputRadiusKey: radius,
                                         kCIInputImageKey: image]
            guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: params) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else {
                fatalError()    // 触发陷阱,   类似与assert 断言
            }
            return outputImage
        }
    }
    
    // 颜色叠层
    func generate(color: UIColor) -> Filter {
        return { _ in
            let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
            let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
            return (filter?.outputImage)!
        }
    }
    
    // 合成滤镜
    func compositeSourceOver(overlay: CIImage) -> Filter {
        return { image in
            let parameters = [kCIInputBackgroundImageKey: image,
                                        kCIInputImageKey: overlay]
            let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
            let outputImage = filter?.outputImage!
            return outputImage!.cropped(to: image.extent)
        }
    }
    
    // 颜色叠层滤镜
    func overlay(color: UIColor) -> Filter {
        return { image in
            let overlay = self.generate(color: color)(image).cropped(to: image.extent)
            return self.compositeSourceOver(overlay: overlay)(image)
        }
    }
    
    // 组合滤镜
    func testImage() {
        let url = URL(string: "")!
        let image = CIImage(contentsOf: url)!
        
        let radius = 5.0
        let color = UIColor.red.withAlphaComponent(0.2)
        // 第一种写法
        let blurredImage = blur(radius: radius)(image)
        let overlaidImage = overlay(color: color)(blurredImage)
        
        // 第二种写法
        // 复合滤镜接 受一个 CIImage 类型的图像参数，然后将该参数传递给  lter1，取得返回值之后再传递给  lter2
        let blurAndOverlay = compose(filter: blur(radius: radius), with: overlay(color: color))
        let result1 = blurAndOverlay(image)
        
        // 第三种写法
        let blurAndOverlay2 = blur(radius: radius) >>> overlay(color: color)
        let result2 = blurAndOverlay2(image)
        
    }
    
    //复合函数
    func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
        return { image in
            filter2(filter1(image))
        }
    }
}

//MARK: 柯里化
extension TestCoreImageVC {
    
    func add(_ x: Int, _ y: Int) -> Int {
        return x + y
    }
    
    func add(_ x: Int) -> (Int) -> Int {
//        return {y in
//          return x + y
//        }
        
        return {y in x + y}   // 内部return 可以省掉
    }
    
    // 将一个接受多参数的函数变换为一系列只接受单个参数的函数, 这个过程成为柯里化(Currying)
    
    func testAdd() {
        print("add:", add(1)(2))
    }
}


