//
//  WCChatViewController.swift
//  WeChat
//
//  Created by 蒋进 on 15/12/24.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class WCChatViewController: UIViewController {
    
    
    //inputView底部约束
    var inputViewConstraint: NSLayoutConstraint!
    //MARK: -  懒加载
    lazy var tableView:UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.greenColor()
        //MARK: -  代码实现自动布局，要设置下面的属性为NO
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    lazy var InputView:WCInputView = {
        
        let inputView: WCInputView  = WCInputView.InputView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupView()
        
        // 添加观察者，监听键盘框架的变化
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChanged:", name: UIKeyboardWillShowNotification, object: nil)
        
        //键盘隐藏
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChanged:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /// 键盘变化监听方法
    func keyboardFrameChanged(notification: NSNotification) {
        
        if notification.name == UIKeyboardWillShowNotification {
            
            // 键盘结束的Frme
            let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let height = rect.size.height
            
            let  duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            //竖屏{{0, 0}, {768, 264}
            //横屏{{0, 0}, {352, 1024}}
            //MARK: -  如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
            if (UIDevice.currentDevice().systemVersion as NSString).doubleValue < 8.0 && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                
                self.inputViewConstraint.constant = rect.size.width
                
            }
            self.inputViewConstraint.constant = height
            UIView.animateWithDuration(duration) {
                self.view.layoutIfNeeded()
            }
        }else{
            self.inputViewConstraint.constant = 0
        }
    }
    

    func setupView(){
        // 代码方式实现自动布局 VFL
        // 创建一个Tableview
        self.view.addSubview(tableView)
        // 创建输入框View
        self.view.addSubview(InputView)

        // 自动布局
        
        // 水平方向的约束
        let views:NSDictionary = ["tableview":tableView,"inputView":InputView]
        // 1.tabview水平方向的约束
        let tabviewHConstraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableview]-0-|",options: [],metrics: nil,
            views: views as! [String : AnyObject]
            )
        self.view.addConstraints(tabviewHConstraints as! [NSLayoutConstraint])
        
        // 2.inputView水平方向的约束
        let inputViewHConstraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[inputView]-0-|",options: [],metrics: nil,
            views: views as! [String : AnyObject]
        )
        self.view.addConstraints(inputViewHConstraints as! [NSLayoutConstraint])
        
        
        // 垂直方向的约束
        let vContraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[tableview]-0-[inputView(50)]-0-|",options: [],metrics: nil,
            views: views as! [String : AnyObject]
        )
        self.view.addConstraints(vContraints as! [NSLayoutConstraint])
        //MARK: - 代码创建的底部约束:
        self.inputViewConstraint = vContraints.lastObject as! NSLayoutConstraint
        NSLog("%@",vContraints);
    }
    


    
}
