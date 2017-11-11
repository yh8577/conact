//
//  BankListCell.swift
//  card
//
//  Created by yihui on 2017/11/6.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class BankListCell: UITableViewCell {

    // 时间
    @IBOutlet weak var newDate: UILabel!
    
    // 用途
    @IBOutlet weak var addAndSubtract: UILabel!
    
    // 💰
    @IBOutlet weak var money: UILabel!
    
    //MARK: --  初始化模型
    var viewModel : BankModel?
    {
        didSet{
            newDate.text = formData((viewModel?.newDate)!)
            addAndSubtract.text = viewModel?.addAndSubtract
            money.text = String(describing: (viewModel?.money)!)
        }
    }
    
    //MARK: -- 格式化时间
    private func formData(_ tempData: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: tempData)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    deinit {
        HHLog("销毁")
    }

}
