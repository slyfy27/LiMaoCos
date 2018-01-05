//
//  MainTabBarItem.swift
//  LiMaoCos
//
//  Created by wushuying on 2018/1/5.
//  Copyright © 2018年 wushuying. All rights reserved.
//

import UIKit

class MainTabBarItem: UIControl {
    var itemDic:Dictionary<String, String>
    let imageView:UIImageView
    let titleLabel:UILabel
    
    var currentSelectState = false{
        didSet{
            if currentSelectState {
                imageView.image = UIImage(named: itemDic["SelectedImg"]!)
                titleLabel.textColor = UIColor.red
            }
            else{
                imageView.image = UIImage(named: itemDic["NormalImg"]!)
                titleLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    init(frame: CGRect, itemDic:Dictionary<String, String>, itemIndex:Int) {
        self.itemDic = itemDic
        
        let defaultLabelH:CGFloat = 20.0
        var imgTop:CGFloat = 7
        var imgWidth:CGFloat = 22
        if itemIndex == 2 {
            imgTop = -12.5
            imgWidth = 50
        }
        let imgLeft:CGFloat = (frame.size.width - imgWidth)/2
        let imgHeight:CGFloat = frame.size.height - defaultLabelH - imgTop
        
        //图片
        imageView = UIImageView(frame: CGRect(x: imgLeft, y: imgTop, width:imgWidth, height:imgHeight))
        imageView.image = UIImage(named: itemDic["NormalImg"]!)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        //title
        titleLabel = UILabel(frame:CGRect(x: 0, y: frame.height - defaultLabelH, width: frame.size.width, height: defaultLabelH))
        titleLabel.text = itemDic["Title"]!
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        titleLabel.textColor = UIColor.lightGray
        
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
