//
//  AddListViewController.swift
//  card
//
//  Created by yihui on 2017/11/6.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController, UITextFieldDelegate {

    // 银行名称
    @IBOutlet weak var bankName: UILabel!
    // 卡号
    @IBOutlet weak var bankCard: UILabel!
    // 用途
    @IBOutlet weak var houston: UILabel!
    // 💰
    @IBOutlet weak var money: UITextField!
    // 标题
    @IBOutlet weak var navTitle: UINavigationItem!
    // 按钮
    @IBOutlet weak var addListButton: UIButton!
    
    // 银行名称
    var bankNameText: String?
    // 卡号
    var bankCardText: Int = 0
    // 用途
    var houstonText: String?
    // 可用额度
    var aCredit: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK:--  初始化UI
    private func setupUI() {
        
        money.delegate = self
        addListButton.layer.cornerRadius = 5
        bankName.text = bankNameText
        bankCard.text = String(bankCardText)
        houston.text = houstonText
        navTitle.title = houstonText
    }

    // MARK:-- 按钮点击方法
    @IBAction func addListClick(_ sender: Any) {
   
        guard let tempMoney = Double(money.text!), money.text != "" else {
            money.text = nil
            Tools.show(self, message: "金额不能为空!")
            return
        }
        
        if houstonText == "还款" {
            aCredit += tempMoney
        } else if houstonText == "消费" {
            aCredit -= tempMoney
        }
        
        let sql = BankData(bankNameText!, bankCard: bankCardText, availableCredit: aCredit, addAndSubtract: houstonText!, money: Double(money.text!)!)
        
        sql.insertData(type: .List)
        
        sql.updateData(type: .List)

        self.navigationController?.popViewController(animated: true)
    }

    // MARK:-- 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:-- deinit
    deinit {
        HHLog("销毁")
    }
    
   
    // MARK:-- 限制UITextField只能输入数字
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //限制只能输入数字，不能输入特殊字符
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            if char == 47 { textField.text = nil; return false }
            if char < 46 { textField.text = nil; return false }
            if char > 57 { textField.text = nil; return false }
        }
        //限制长度
        let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        if proposeLength > 11 { return false }
        return true
    }
}
