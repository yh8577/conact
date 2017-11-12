//
//  UserLoginViewController.swift
//  card
//
//  Created by yihui on 2017/11/10.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController {

    // 密码
    @IBOutlet weak var passField: UITextField!
    // 登陆按钮
    @IBOutlet weak var loginButton: UIButton!
    // passField 约束
    @IBOutlet weak var centerAlignPass: NSLayoutConstraint!
    // Login约束
    @IBOutlet weak var centerAlignLogin: NSLayoutConstraint!
    // 图标image最大x
    @IBOutlet weak var bottomIconImage: NSLayoutConstraint!
    // 按钮顶部约束
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    // 按钮底部约束
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    // 问题约束
    @IBOutlet weak var centerProblem: NSLayoutConstraint!
    // 答案约束
    @IBOutlet weak var centerAnswer: NSLayoutConstraint!
    // 问题顶部约束
    @IBOutlet weak var problemTopConstraint: NSLayoutConstraint!
    // 找回密码问题
    @IBOutlet weak var problemField: UITextField!
    // 找回密码答案
    @IBOutlet weak var answerfield: UITextField!
    
    @IBOutlet weak var askButton: UIButton!
    
    // 数据模型
    private var pass : [BankModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载UI
        setuoUI()
        // 加载通知
        setupNotification()
        
    }
    
    //MARK: -- 获取数据
    private func loadData() {
        
        pass = BankData.loadData(where: nil, type: .Pass)

    }
    
    //MARK: -- 监听键盘通知
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbFrameChanged(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    //MARK: -- 初始化UI
    private func setuoUI() {
        
        buttonTopConstraint.constant = 20
        buttonBottomConstraint.constant = 150
        loginButton.layer.cornerRadius = 5
    }
    
    //MARK: -- 弹出键盘上移UI
    @objc private func kbFrameChanged(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }
    
    //MARK: -- 关闭键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: -- 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 加载数据
        loadData()
        // 上移隐藏icon
        self.bottomIconImage.constant += 450
        // 设置登录按钮透明
        loginButton.alpha = 0
        // 隐藏问题
        centerProblem.constant = -view.bounds.width
        // 隐藏答案
        centerAnswer.constant = -view.bounds.width
        // 左移动隐藏密码输入框
        centerAlignPass.constant -= view.bounds.width
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 如果没有设置过密码显示设置密码 UI
        if pass?.count == nil || (pass?.count)! < 1 {
            problemField.isHidden = false
            answerfield.isHidden = false
            buttonTopConstraint.constant = 90
            buttonBottomConstraint.constant = 60
            loginButton.setTitle("第一次使用请先设置密码", for: .normal)
            
        } else {// 有密码显示登录 UI

            buttonTopConstraint.constant = 10
            buttonBottomConstraint.constant = 150
            loginButton.setTitle("GO", for: .normal)
            self.view.layoutIfNeeded()
        }
        
        setupAnimate()
        
    }
    
    //MARK: -- 登录界面UI动画
    private func setupAnimate() {
        // icon动画
        UIView.animate(withDuration: 2.0, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            self.bottomIconImage.constant -= 450
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        // 密码输入框动画
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
            self.centerAlignPass.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            
        }, completion:{ (_) in
           
            if self.pass?.count == nil || (self.pass?.count)! < 1 {
                
                // 问题输入框动画
                UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
                    self.centerProblem.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                    
                }, completion:{ (_) in
                    // 答案输入框动画
                    UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
                        self.centerAnswer.constant += self.view.bounds.width
                        self.view.layoutIfNeeded()
                        
                    }, completion:nil)
                })
                
            }
        })
        
        // 按钮动画
        UIView.animate(withDuration: 3.0, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            self.loginButton.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    
    // MARK: -- 找回密码按钮 点击事件
    // 按钮Tag值
    var passRetrievalTag = 1
    
    @IBAction func passRetrievalClick(_ sender: Any) {
        
        if passRetrievalTag == 1 { // 找回密码问题验证
            
            passField.isHidden = true
            problemField.isHidden = false
            answerfield.isHidden = false
            problemField.isEnabled = false
            problemField.text = pass?.last?.problem
            centerProblem.constant += self.view.bounds.width
            centerAnswer.constant += self.view.bounds.width
            problemTopConstraint.constant = -30
            buttonTopConstraint.constant = 50
            buttonBottomConstraint.constant = 100
            loginButton.setTitle("找回密码", for: .normal)
            askButton.setTitle("<-", for: .normal)
            animAsk()
            passRetrievalTag = 2
            passTag = 1
            self.view.layoutIfNeeded()
            return
            
        } else if passRetrievalTag == 2 { // 还原登录UI
            
            askButton.setTitle("?", for: .normal)
            passField.isHidden = false
            viewWillAppear(true)
            viewDidAppear(true)
            passTag = 0
            passRetrievalTag = 1
            view.layoutIfNeeded()
            return
        }
        
    }
    
    // MAKE: -- 问题,答案输入框动画
    func animAsk() {
        problemField.alpha = 0
        answerfield.alpha = 0
        loginButton.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.problemField.alpha = 1.0
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
                self.answerfield.alpha = 1.0
            }) { (_) in
                UIView.animate(withDuration: 0.5) {
                    self.loginButton.alpha = 1.0
                }
            }
        }
    }
    
    var passTag = 0
    //MARK: -- 按钮点击事件
    @IBAction func loginClick(_ sender: Any) {
        
        if passTag == 0 {
            // 登录验证
            loginCheck()
        }
        if passTag == 1 || passTag == 2 {
            // 找回更新密码
            updatePass()
        }
    }
    
    // MARK: -- 找回更新密码
    private func updatePass() {
        // 验证输入
        guard let answerText = answerfield.text, answerfield.text != ""  else {
            Tools.show(self, message: "答案不能空!")
            return
        }
        // 找回密码
        if passTag == 1 {
            // 验证答案是否正确
            if pass?.last?.answer != answerText {
                Tools.show(self, message: "答案错误!")
                return
            }
            // 答案正确 修改UI,显示设置新密码UI
            passField.isHidden = false
            problemTopConstraint.constant = 10
            buttonTopConstraint.constant = 90
            buttonBottomConstraint.constant = 60
            loginButton.setTitle("确定修改", for: .normal)
            passField.placeholder = "请输入新密码!"
            // 刷新UI界面
            self.view.layoutIfNeeded()
            passTag = 2
            return
        }
        
        // 验证输入
        guard let tempPass = passField.text, passField.text != "" else {
            passField.text = nil
            Tools.show(self, message: "请输入密码!")
            return
        }
        
        // 更新密码
        if passTag == 2 {
            // 保存密码
            BankData(passMd5(tempPass),problem: (pass?.last?.problem)!,answer: answerText).updateData(type: .Pass)
            // 还原登录UI
            passTag = 0
            askButton.setTitle("?", for: .normal)
            passField.placeholder = "请输入密码!"
            // 清空输入框
            problemField.text = nil
            answerfield.text = nil
            passField.text = nil
            // 提示
            Tools.show(self, message: "成功修改资料!")
            // 重新加载页面
            viewWillAppear(true)
            viewDidAppear(true)
            return
        }
    }
    
    // MARK: -- 登录验证,保存密码,问题和答案
    private func loginCheck() {
        
        // 验证输入
        guard let tempPass = passField.text, passField.text != "" else {
            passField.text = nil
            Tools.show(self, message: "请输入密码!")
            return
        }
        
        if pass?.count == 1 { // 有设置过密码判断密码是否正确
            
            if pass?.last?.passWord == passMd5(tempPass) {
                
                passField.text = nil
                view.endEditing(true)
                
                self.performSegue(withIdentifier: "Home", sender: nil)
                
            } else { // 密码不正确
                
                Tools.show(self, message: "密码错误!")
                passField.text = nil
            }
            
            return
            
        }  else if pass?.count == nil || (pass?.count)! < 1 {
            // 输入框验证
            guard let problemText = problemField.text, problemField.text != "" else {
                Tools.show(self, message: "问题不能空!")
                return
            }
            guard let answerText = answerfield.text, answerfield.text != ""  else {
                Tools.show(self, message: "答案不能空!")
                return
            }
            // 保存资料到数据库
            BankData(passMd5(tempPass),problem: problemText,answer: answerText).insertData(type: .Pass)
            // 清空输入框
            passField.text = nil
            problemField.text = nil
            answerfield.text = nil
            // 关闭键盘
            view.endEditing(true)
            // 直接进入主页
            self.performSegue(withIdentifier: "Home", sender: nil)
            
            return
        }
        
        
    }
    
    // MARK: -- MD5加密
    private func passMd5(_ pass: String) -> String {
        let tempPass = pass + "580131"
        return tempPass.md5()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // 删除通知
        NotificationCenter.default.removeObserver(self)
        HHLog("销毁")
    }

}
