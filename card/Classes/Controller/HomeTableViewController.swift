//
//  TableViewController.swift
//  card
//
//  Created by yihui on 2017/11/5.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    // 数据模型
    private var viewModel : [BankModel]?
    // 总额度
    @IBOutlet weak var totalAmounts: UILabel!
    // 可用
    @IBOutlet weak var availableCredits: UILabel!
    // 欠
    @IBOutlet weak var owes: UILabel!
    // 总统计View
    @IBOutlet weak var statisticsView: UIView!
    // 总额度
    private var zTotalAmount: Double = 0.0
    // 可用
    private var zAvailableCredit: Double = 0.0
    // 欠
    private var zOwe: Double = 0.0
    // 中心Button
    private var addCardButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化UI
        setupUI()

    }
    
    // MARK: -- 初始化UI
    private func setupUI() {
        
        statisticsView.alpha = 0.0
        statisticsView.layer.cornerRadius = 4
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    private func loadData() {
        
        // 获取数据
        viewModel = BankData.loadData(where: nil,type: .Card)
        // 统计金额
        statisticsMoney()
        
        // 是否显示中间按钮
        if (viewModel?.count) == 0 {
            addCardButton = setAddCardButton()
        } else {
            addCardButton?.isHidden = true
        }
        
        tableView.reloadData()
    }

    // MARK: -- 生命周期方法
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 加载数据
        loadData()
        
        // 加载 中间按钮
        animateAddCardButton()
        // 加载 tableview cell 动画
        animateTable()

    }

    
    // MARK: -- 中间按钮
    private func setAddCardButton() -> UIButton {
        
        let btn = UIButton()
        btn.frame.origin = CGPoint(x: (WIDTH - 300) * 0.5, y: (HEIGHT - 200) * 0.5)
        btn.frame.size = CGSize(width: 300, height: 200)
        btn.layer.cornerRadius = 100
        btn.clipsToBounds = true
        btn.setTitle("还没有银行卡请点我添加银行卡", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .highlighted)
        btn.backgroundColor = #colorLiteral(red: 0.9662002921, green: 0.5806997418, blue: 0.3578594327, alpha: 1)
        btn.addTarget(self, action: #selector(self.addCardClick), for: .touchUpInside)
        view.addSubview(btn)
        return btn
    }
    
    // MARK: -- 中间按钮点击事件
    @objc private func addCardClick() {
        
        self.performSegue(withIdentifier: "addCard", sender: nil)
    }
    // 中间按钮动画
    private func animateAddCardButton() {
        addCardButton?.frame = CGRect(x: WIDTH * 0.5, y: HEIGHT * 0.5, width: 50, height: 50)
        self.loadViewIfNeeded()
        
        UIView.animate(withDuration: 1.5, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.addCardButton?.frame = CGRect(x: (WIDTH - 300) * 0.5, y: (HEIGHT - 200) * 0.5, width: 300, height: 200)
            self.loadViewIfNeeded()
        }, completion: nil)
      
    }
    
    // MARK: -- 统计金额
    private func statisticsMoney() {
        
        zTotalAmount = 0.0
        zAvailableCredit = 0.0
        totalAmounts.text = "总: 0.0"
        availableCredits.text = "可: 0.0"
        owes.text = "欠: 0.0"
        
        for item in viewModel! {
            zTotalAmount += item.totalAmount
            zAvailableCredit += item.availableCredit
        }
        totalAmounts.text = "总:" + Tools.calculation(zTotalAmount)
        availableCredits.text = "可:" + Tools.calculation(zAvailableCredit)
        owes.text = "欠:" + Tools.calculation(zTotalAmount-zAvailableCredit)
    }

    // MARK: -- tableview cell 动画
    func animateTable() {
        tableView.alpha = 1.0
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        statisticsView.alpha = 0.0
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.statisticsView.alpha = 1.0
                })
            })
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = self.viewModel?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeBankCell
        
        cell.layer.cornerRadius = 4
        
        cell.viewModel = viewModel
        
        return cell
    }
    

    // MARK: -- tableView 侧滑按钮
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let viewModel = self.viewModel?[indexPath.item]

        //右侧第一个按钮
        let actionOne = UITableViewRowAction(style: .normal, title: "删除") {_,_ in
            self.viewModel!.remove(at: indexPath.item)
            // 删除数据
            BankData.deleteData((viewModel?.bankCard)!,type: .Card)
            // 刷新数据
            self.viewDidAppear(true)
        }
        //背景颜色
        actionOne.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        //右侧第二个按钮
        let actionTwo = UITableViewRowAction(style: .normal, title: "编辑") {_,_ in

            self.performSegue(withIdentifier: "edit", sender: viewModel)
        }
        //背景颜色
        actionTwo.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        return [actionOne, actionTwo]
    }
    
    // MARK: -- tableView 背景颜色设置
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor =  colorforIndex(indexPath.row)
        
    }
    
    // MARK: -- tableView 背景颜色
    func colorforIndex(_ index: Int) -> UIColor {
        
        let itemCount = (viewModel?.count)! - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.3, alpha: 0.8)
        
    }
    
    // MARK: -- 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 明细
        if (segue.identifier == "details") {
            tableView.alpha = 0
            let cell = sender as! HomeBankCell
            var bankListVC : BankListTableViewController!
            bankListVC = segue.destination as! BankListTableViewController
            bankListVC.bankCardText = (cell.viewModel?.bankCard)!
            bankListVC.bankNameText = cell.viewModel?.bankName
            
        } else if (segue.identifier == "edit") {
            
        // 修改卡信息
            tableView.alpha = 0
            let editVc = segue.destination as! AddBankCardViewController
            let viewModel = sender as? BankModel
            editVc.edit = "edit" 
            editVc.bankNameText = (viewModel?.bankName)!
            editVc.bankCardText = (viewModel?.bankCard)!
            editVc.totalAmountText = (viewModel?.totalAmount)!
            editVc.availableCreditText = (viewModel?.availableCredit)!
            editVc.provisionalQuotaText = (viewModel?.provisionalQuota)!
        } else if (segue.identifier == "addList") || (segue.identifier == "addList1") {
        // 还款消费
            tableView.alpha = 0
            let btn = sender as! UIButton
            let cell = btn.superView(of: HomeBankCell.self)!
            let listVC = segue.destination as! AddListViewController
            listVC.bankNameText = cell.viewModel?.bankName
            listVC.bankCardText = (cell.viewModel?.bankCard)!
            listVC.aCredit = (cell.viewModel?.availableCredit)!
            if (segue.identifier == "addList") {
                listVC.houstonText = "还款"
            }else  if (segue.identifier == "addList1") {
                listVC.houstonText = "消费"
            }
        } else if (segue.identifier == "addCard") {
            tableView.alpha = 0
        }
    
    }
    
    // MARK: -- deinit
    deinit {
        HHLog("销毁")
    }
    // MARK: -- 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: -- UIview 扩展
extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}


