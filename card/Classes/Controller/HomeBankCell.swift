//
//  BankCell.swift
//  card
//
//  Created by yihui on 2017/11/6.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class HomeBankCell: UITableViewCell {
    
    // 银行名称
    @IBOutlet weak var bankName: UILabel!
    // 卡号
    @IBOutlet weak var bankCard: UILabel!
    // 总额
    @IBOutlet weak var totalAmount: UILabel!
    // 临额
    @IBOutlet weak var provisionalQuota: UILabel!
    // 可用
    @IBOutlet weak var availableCredit: UILabel!
    // 欠
    @IBOutlet weak var owe: UILabel!
    // 还款按钮
    @IBOutlet weak var repaymentButton: UIButton!
    // 消费按钮
    @IBOutlet weak var consumptionButton: UIButton!
    //MARK: -- 初始化模型
    var viewModel : BankModel?
    {
        didSet{
            
            guard let bName = viewModel?.bankName else {
                return
            }
            
            guard let bCard = viewModel?.bankCard else {
                return
            }
            
            guard let tAmount = viewModel?.totalAmount else {
                return
            }
            
            guard let pQuota = viewModel?.provisionalQuota else {
                return
            }
            
            guard let aCredie = viewModel?.availableCredit else {
                return
            }
            
            bankName.text = bName
            bankCard.text = String(bCard)
            totalAmount.text = "总:\(Tools.calculation(tAmount))"
            provisionalQuota.text = "临:\(Tools.calculation(pQuota))"
            availableCredit.text = "可:\(Tools.calculation(aCredie))"
            owe.text = "欠:\(Tools.calculation(tAmount - aCredie))"
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        repaymentButton.layer.cornerRadius = 5
        consumptionButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        HHLog("销毁")
    }

}


