//
//  ViewController.swift
//  SoundSampler
//
//  Created by 工藤征生 on 2016/03/26.
//  Copyright © 2016年 Aquaware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = NSBundle.mainBundle().URLForResource("M1F1int16", withExtension: "aif")!
        let resource = SoundSampler(url: url)
        
        let size = resource.data.length / sizeof(Int16)
        var data: [Int16] = [Int16](count: size, repeatedValue: 0)
        resource.data.getBytes(&data, length: resource.data.length)
        
        for var i = 1000; i < 1100; i++ {
            print("\(data[i]) ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

