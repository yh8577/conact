//
//  Bank.swift
//  card
//
//  Created by yihui on 2017/11/6.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class Bank: NSObject {
    
    // 银行卡号
    var bankName : String?
    // 银行卡号
    var bankCard : Int = 0
    // 总额度
    var totalAmount : Double = 0.0
    // 临时额度
    var provisionalQuota : Double = 0.0
    // 可用额度
    var availableCredit : Double = 0.0
    // 用途
    var addAndSubtract : String?
    // 金额
    var money : Double = 0.0
    // 日期
    var newDate = Date()
    // id
    var id : Int = 0
    // 密码
    var passWord : String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["bankName","bankCard","totalAmount","provisionalQuota","availableCredit","addAndSubtract","money","newDate","passWord","id"]
        let dict = dictionaryWithValues(forKeys: property)

        return "\(dict)"
    }
    
}
