//
//  MainTabBarView.swift
//  LiMaoCos
//
//  Created by wushuying on 2018/1/5.
//  Copyright © 2018年 wushuying. All rights reserved.
//

import UIKit

extension String{
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
}

extension UIColor {
    
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    convenience init(hexColor: String) {
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: hexColor[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColor[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColor[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}

protocol MainTabBarDelegate {
    func didSelectedItem(itemIndex:Int)
}

class MainTabBarView: UIView {
    var delegate:MainTabBarDelegate?
    var itemArray:[MainTabBarItem] = []
    
    init(frame: CGRect, tabbarConfigArr:[Dictionary<String,String>]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let sepView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        sepView.backgroundColor = UIColor.init(hexColor: "d7d7d7")
        self.addSubview(sepView)
        let screenW = UIScreen.main.bounds.size.width
        let itemWidth = screenW / CGFloat(tabbarConfigArr.count)
        for i in 0..<tabbarConfigArr.count{
            let itemDic = tabbarConfigArr[i];
            let itemFrame = CGRect(x: itemWidth * CGFloat(i) , y: 0, width: itemWidth, height: frame.size.height)
            //创建Item视图
            let itemView = MainTabBarItem(frame: itemFrame, itemDic:itemDic, itemIndex: i)
            self.addSubview(itemView)
            self.itemArray.append(itemView)
            //添加事件点击处理
            itemView.tag = i
            itemView.addTarget(self, action: #selector(self.didItemClick(item:)), for: UIControlEvents.touchUpInside)
            //默认点击第一个,即首页
            if i == 0 {
                self.didItemClick(item: itemView)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //点击单个标签视图，通过currentSelectState的属性观察器更新标签item的显示
    //并且通过代理方法切换标签控制器的当前视图控制器
    @objc func didItemClick(item:MainTabBarItem){
        for i in 0..<itemArray.count{
            let tempItem = itemArray[i]
            if i == item.tag{
                tempItem.currentSelectState = true
            }else{
                tempItem.currentSelectState = false
            }
        }
        //执行代理方法
        self.delegate?.didSelectedItem(itemIndex: item.tag)
    }
}
