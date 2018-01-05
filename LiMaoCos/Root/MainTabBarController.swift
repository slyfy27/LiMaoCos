//
//  MainTabBarController.swift
//  LiMaoCos
//
//  Created by wushuying on 2018/1/5.
//  Copyright © 2018年 wushuying. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController ,MainTabBarDelegate{
    func didSelectedItem(itemIndex: Int) {
        self.selectedIndex = itemIndex
    }
    
    var tarbarConfigArr:[Dictionary<String,String>]! //标签栏配置数组，从Plist文件中读取
    var mainTabBarView: MainTabBarView! //自定义的底部TabbarView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.tarbarConfigArr = self.getConfigArrFromPlistFile()
        self.createControllers()
        self.createMainTabBarView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func getConfigArrFromPlistFile() ->([Dictionary<String,String>]?){
        let  filePath: String? = Bundle.main.path(forResource: "MainTabBarConfig", ofType: "plist")
        let plistData = NSDictionary(contentsOfFile: filePath ?? "")
        let configArr = plistData?.object(forKey: "Tabbars") as? [Dictionary<String,String>]
        return configArr;
    }
    
    //创建视图控制器
    private func createControllers(){
        var controllerNameArray = [String]() //控制器类名数组
        var controllerTitle = [String]()     //控制器Title数组
        for dictionary in self.tarbarConfigArr{
            controllerNameArray.append(dictionary["ViewController"]!);
            controllerTitle.append(dictionary["Title"]!)
            
            guard controllerNameArray.count > 0 else{
                print("error:控制器数组为空")
                return
            }
            //初始化导航控制器数组
            var nvcArray = [BaseNavigationController]()
            //在Swift中, 通过字符串创建一个类, 那么必须加上命名空间clsName
            let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            for i in 0...controllerNameArray.count-1 {
                //动态获取的命名空间是不包含.的, 所以需要我们自己手动拼接
                let anyClass: AnyClass? = NSClassFromString(clsName + "." + controllerNameArray[i])
                //将AnyClass类型转换为BaseViewController类型，
                //因为Swift中通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
                if let vcClassType = anyClass as? BaseViewController.Type {
                    let viewcontroller = vcClassType.init()
                    viewcontroller.title = controllerTitle[i]
                    let nav = BaseNavigationController(rootViewController:viewcontroller)
                    nvcArray.append(nav)
                }
            }
            //设置标签栏控制器数组
            self.viewControllers = nvcArray
        }
    }
    
    //创建自定义Tabbar
    private func createMainTabBarView(){
        //1.获取系统自带的标签栏视图的frame,并将其设置为隐藏
        let tabBarRect = self.tabBar.frame;
        self.tabBar.isHidden = true;
        //3.使用得到的frame，和plist数据创建自定义标签栏
        mainTabBarView = MainTabBarView(frame: tabBarRect,tabbarConfigArr:tarbarConfigArr!);
        mainTabBarView.delegate = self
        self.view .addSubview(mainTabBarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
