//
//  AddBankCardViewController.swift
//  card
//
//  Created by yihui on 2017/11/5.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class AddBankCardViewController: UIViewController, UITextFieldDelegate {

    // 银行名称
    @IBOutlet weak var bankName: UITextField!
    // 银行卡号
    @IBOutlet weak var bankCard: UITextField!
    // 总额度
    @IBOutlet weak var totalAmount: UITextField!
    // 临时额度
    @IBOutlet weak var provisionalQuota: UITextField!
    // 可用额度
    @IBOutlet weak var availableCredit: UITextField!
    // 按钮
    @IBOutlet weak var addCardButton: UIButton!
    // nav标题
    @IBOutlet weak var navTitle: UINavigationItem!
    // 银行名称
    var bankNameText = String()
    // 卡号
    var bankCardText : Int = 0
    // 总额度
    var totalAmountText : Double = 0.0
    // 临时额度
    var provisionalQuotaText : Double = 0.0
    // 可用额度
    var availableCreditText : Double = 0.0
    
    var edit : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK:--  初始化UI
    private func setupUI() {
        addCardButton.layer.cornerRadius = 5
        bankCard.delegate = self
        totalAmount.delegate = self
        provisionalQuota.delegate = self
        availableCredit.delegate = self
        // 来自编辑
        if edit == "edit" {
            
            bankName.isEnabled = false
            bankCard.isEnabled = false
            bankName.text = bankNameText
            bankCard.text = String(bankCardText)
            totalAmount.text = String(totalAmountText)
            provisionalQuota.text = String(provisionalQuotaText)
            availableCredit.text = String(availableCreditText)
            navTitle.title = "编辑银行卡"
            addCardButton.setTitle("确定修改", for: .normal)
        }
    }

    // MARK:-- 按钮点击方法
    @IBAction func AddCardClick(_ sender: Any) {
    
        guard let bName = bankName.text, bankName.text != "" else {
            Tools.show(self, message: "名称空!")
            return
        }

        guard let bCard = Int(bankCard.text!), bankCard.text != "" else {
            Tools.show(self, message: "卡号空!")
            return
        }

        guard let tAmount = Double(totalAmount.text!), totalAmount.text != "" else {
            Tools.show(self, message: "总额度空!")
            return
        }
        
        guard let pQuota = Double(provisionalQuota.text!), provisionalQuota.text != "" else {
            return provisionalQuota.text = "0"
        }
        
        guard let aCredit = Double(availableCredit.text!), availableCredit.text != "" else {
            Tools.show(self, message: "可用额度空!")
            return
        }
        
        // 编辑
        if edit == "edit" {
            let sql = BankData(bName, bankCard: bCard, totalAmount: tAmount, provisionalQuota: pQuota, availableCredit: aCredit)
                sql.updateData(type: .Card)
        } else { // 添加
            
            let sql = BankData(bName, bankCard: bCard, totalAmount: tAmount, provisionalQuota: pQuota, availableCredit: aCredit)
            
            sql.insertData(type: .Card)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: -- 限制UITextField只能输入数字
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
        if proposeLength > 17 { return false }
        return true
    }
    
    //MARK: -- deinit
    deinit {
        HHLog("销毁")
    }

}


