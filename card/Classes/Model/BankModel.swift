//
//  BankModel.swift
//  card
//
//  Created by yihui on 2017/11/6.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class BankModel: NSObject {

    var bank : Bank
    
    init(bank: Bank){
        self.bank = bank
        
        bankName = bank.bankName
        bankCard = bank.bankCard
        totalAmount = bank.totalAmount
        provisionalQuota = bank.provisionalQuota
        availableCredit = bank.availableCredit
        addAndSubtract = bank.addAndSubtract
        money = bank.money
        newDate = bank.newDate
        id = bank.id
        passWord = bank.passWord
        problem = bank.problem
        answer = bank.answer
     
    }
    
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
    // 欠
//    var owe : Double = 0.0
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
    // 问题
    var problem : String?
    // 答案
    var answer : String?
}
