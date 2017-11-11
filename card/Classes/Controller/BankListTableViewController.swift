//
//  BankListTableViewController.swift
//  card
//
//  Created by yihui on 2017/11/6.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class BankListTableViewController: UITableViewController {
    
    private var viewModel : [BankModel]?
    // 银行名称
    var bankNameText: String?
    // 卡号
    var bankCardText: Int = 0
    // 总还款
    private var repayment: Double = 0.0
    // 总消费
    private var consumption: Double = 0.0
    // 银行名称
    @IBOutlet weak var bankNameLabel: UILabel!
    // 卡号
    @IBOutlet weak var bankCardLabel: UILabel!
    // 总还款
    @IBOutlet weak var repaymentLabel: UILabel!
    // 总消费
    @IBOutlet weak var consumptionLabel: UILabel!
    // 顶部View
    @IBOutlet weak var topView: UIView!
    // 底部View
    @IBOutlet weak var bottonView: UIView!
    
    // MARK:-- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    // MARK:-- 初始化UI
    private func setupUI() {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        topView.layer.cornerRadius = 4
        bottonView.layer.cornerRadius = 4
        
        viewModel = BankData.loadData(where: bankCardText,type: .List)
        bankNameLabel.text =  "银行: " + bankNameText!
        bankCardLabel.text =  "卡号: " + String(bankCardText)
    }
    
    // MARK:-- tableView 加载动画
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    // MARK:-- tableView 动画
    func animateTable() {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        bottonView.alpha = 0
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottonView.alpha = 1.0
                    self.loadViewIfNeeded()
                })
            })
        }
    }

    // MARK:-- tableView 数据源代理方法
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = self.viewModel?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Listcell", for: indexPath) as! BankListCell
        
        cell.layer.cornerRadius = 4
        
        if viewModel?.addAndSubtract == "还款" {
            repayment += (viewModel?.money)!
        } else {
            consumption += (viewModel?.money)!
        }
        repaymentLabel.text = "总还款: " +  Tools.calculation(repayment)
        consumptionLabel.text = "总消费: " + Tools.calculation(consumption)
        
        cell.viewModel = viewModel

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath)
        -> String? {
            return "删除"
    }
    
    //编辑完毕（这里只有删除操作）
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            let viewModel = self.viewModel?[indexPath.row]
            self.viewModel!.remove(at: (indexPath as NSIndexPath).row)
            
            BankData.deleteData((viewModel?.id)!,type: .List)
            repayment = 0.0
            consumption = 0.0
            repaymentLabel.text = "总还款: 0.0"
            consumptionLabel.text = "总消费: 0.0"
            self.tableView!.reloadData()
            
            HHLog("你确认了删除按钮")
        }
    }
    
    // MARK:-- tableView 设置颜色
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor =  colorforIndex(indexPath.row)
    }
    
    // MARK:-- tableView 颜色
    private func colorforIndex(_ index: Int) -> UIColor {
        let itemCount = (viewModel?.count)! - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
        
    }
    
    // MARK:-- deinit
    deinit {
        HHLog("销毁")
    }
    // MARK:-- 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
