//
//  ShowAlert.swift
//  card
//
//  Created by yihui on 2017/11/10.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit
import Foundation

let GFB_ALTER_MSG = "提示"

class Tools {

    //MARK: -- 弹出提示
    class func show(_ vc: UIViewController, message: String){
        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        alertVC.addAction(acSure)
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: -- 格式化金额
    class func calculation(_ money: Double) -> String {
        
        var str = money
        
        if str >= 10000 || str <= 10000 {
            str = str / 10000
            return "\(String(format: "%.2f",str)) 万"
        }
        
        return "\(String(format: "%.2f",str)) 元"
    }
}

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
}


