//
//  BankData.swift
//  card
//
//  Created by yihui on 2017/11/5.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

enum dataType {
    case Card
    case List
    case Pass
}

class BankData: NSObject {
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
    // 密码
    var passWord : String?
    // 问题
    var problem : String?
    // 答案
    var answer : String?
    
    override init() {
        super.init()
        
    }
    
    init(_ bankName : String, bankCard : Int, totalAmount : Double, provisionalQuota : Double, availableCredit : Double) {
        
        self.bankName = bankName
        self.bankCard = bankCard
        self.totalAmount = totalAmount
        self.provisionalQuota = provisionalQuota
        self.availableCredit = availableCredit
    }
    
    init(_ bankName : String, bankCard : Int, availableCredit : Double, addAndSubtract: String, money: Double) {
        
        self.bankName = bankName
        self.bankCard = bankCard
        self.availableCredit = availableCredit
        self.addAndSubtract = addAndSubtract
        self.money = money 
        
    }
    
    init(_ passWord: String, problem: String, answer: String) {
        self.passWord = passWord
        self.problem = problem
        self.answer = answer
    }
    
    
    init(dict : [String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    
    func updateData(type: dataType) {
        
        var updateSQL: String?
        if String(describing: type) == "Card" {
            
            updateSQL = "UPDATE bankData SET bankName = '\(bankName!)', bankCard = \(bankCard), totalAmount = \(totalAmount), provisionalQuota = \(provisionalQuota),  availableCredit = \(availableCredit) WHERE bankName = '\(bankName!)' AND bankCard = \(bankCard) ;"
            
        }  else if String(describing: type) == "List" {
            
            updateSQL = "UPDATE bankData SET availableCredit = \(availableCredit) WHERE bankCard = \(bankCard);"
        } else if String(describing: type) == "Pass" {
            updateSQL = "UPDATE userPass SET passWord = '\(passWord!)', problem = '\(problem!)', answer = '\(answer!)' WHERE id = 1;"
        }
        
        if SQLiteManager.shareInstance().execSQL(updateSQL!) {
            HHLog("更新数据成功")
        }
    }
    
    func insertData(type: dataType) {
        
        // 1.封装插入的SQL
        var insertSQL: String?
        
        if String(describing: type) == "Card" {
            
            insertSQL = "INSERT INTO bankData (bankName, bankCard, totalAmount, provisionalQuota, availableCredit) VALUES ('\(bankName!)',\(bankCard),\(totalAmount),\(provisionalQuota),\(availableCredit));"
        } else if String(describing: type) == "List" {
            
            insertSQL = "INSERT INTO bankList (bankName, bankCard, addAndSubtract, money) VALUES ('\(bankName!)',\(bankCard),'\(addAndSubtract!)',\(money));"
        } else if String(describing: type) == "Pass" {
            insertSQL = "INSERT INTO userPass (passWord, problem, answer) VALUES ('\(passWord!)', '\(problem!)', '\(answer!)');"
        }
        
        // 2.执行SQL
        if SQLiteManager.shareInstance().execSQL(insertSQL!) {
            HHLog("插入数据成功")
        }
    }
    
    class func deleteData(_ id: Int, type: dataType) {
        // 1.封装删除的SQL
        var deleteSQL: String?
        if String(describing: type) == "List" {
            
            deleteSQL = "DELETE FROM bankList WHERE id = \(id);"
            
        } else if String(describing: type) == "Card" {
            
            deleteSQL = "DELETE FROM bankData WHERE bankCard = \(id);"
            deleteSQL! += "DELETE FROM bankList WHERE bankCard = \(id);"
        }

        // 2.执行sql
        if SQLiteManager.shareInstance().execSQL(deleteSQL!) {
            HHLog("删除成功")
        }
    }
    
    class func loadData(where card: Int?, type: dataType) -> [BankModel]? {
        
        var querySQL: String?
        
        if String(describing: type) == "Card" {
            // 1.封装查询语句
            querySQL = "SELECT * FROM bankData;";
        } else if String(describing: type) == "List" {
            querySQL = "SELECT * FROM bankList WHERE bankCard = \(card!);";
        } else if String(describing: type) == "Pass" {
            querySQL = "SELECT * FROM userPass WHERE id = 1;";
            
        }
        
        // 2.执行查询语句
        let dictArray = SQLiteManager.shareInstance().querySQL(querySQL!)
        
        // 3.判断数组如果有值,则遍历,并且转成模型对象,放入另外一个数组中
        if let tempDictArray = dictArray {
            var tempArray = [BankModel]()
            for dict in tempDictArray {
                
                let bank = Bank(dict: dict)
                let viewModel = BankModel(bank: bank)
                tempArray.append(viewModel)
            }
            
            return tempArray
        }
        
        return nil
    }
}
