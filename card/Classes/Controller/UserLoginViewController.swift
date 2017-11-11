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
    
    // 数据模型
    private var pass : [BankModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuoUI()
        setupNotification()
        loadData()
        
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

        // 上移隐藏icon
        self.bottomIconImage.constant += 450
        self.view.layoutIfNeeded()
        // 左移动隐藏密码输入框
        centerAlignPass.constant -= view.bounds.width
        // 设置按钮透明
        loginButton.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 如果没有设置过密码修改按钮显示问题
        if pass?.count == nil || (pass?.count)! < 1 {
            loginButton.setTitle("第一次使用请先设置密码", for: .normal)
        }
        
        setupAnimate()
       
    }
    
    //MARK: -- UI动画
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
            
        }, completion: { (_) in
            
            // 按钮动画
            UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
                self.loginButton.alpha = 1
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        })
    }
    
    //MARK: -- 按钮点击事件
    @IBAction func loginClick(_ sender: Any) {
        
        guard let tempPass = passField.text, passField.text != "" else {
            passField.text = nil
            Tools.show(self, message: "请输入密码!")
            return
        }
        
        // 没有设置过密码执行保存密码
        if pass?.count == nil || (pass?.count)! < 1 {
            
            BankData(passMd5(tempPass)).insertData(type: .Pass)
            passField.text = nil
            view.endEditing(true)
            
            self.performSegue(withIdentifier: "Home", sender: nil)
            
        } else if pass?.count == 1 { // 有设置过密码判断密码是否正确

            if pass?.last?.passWord == passMd5(tempPass) {
                
                passField.text = nil
                view.endEditing(true)

                self.performSegue(withIdentifier: "Home", sender: nil)
                
            } else { // 密码不正确
                
                Tools.show(self, message: "密码错误!")
                passField.text = nil
            }
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
        NotificationCenter.default.removeObserver(self)
        HHLog("销毁")
    }

}
