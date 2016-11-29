//
//  MyTabBarController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

+ (MyTabBarController *)shareTabBar{
    static MyTabBarController *tabBarCtrl;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!tabBarCtrl) {
            tabBarCtrl = [[MyTabBarController alloc]init];
        }
    });
    return tabBarCtrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarItem];
}

- (void)createBarItem{
    self.tabBar.tintColor = KColorRGB(19, 153, 229);
    NSArray *viewCtrl = @[@"ApplyViewController",@"TestViewController",@"RidersViewController",@"MyViewController"];
    NSArray *navTitles = @[@"",@"驾校中国",@"驾考圈",@"个人主页"];
    NSArray *itemImages = @[@"tabbar_icon_buy_normal",@"tabbar_icon_kao_normal",@"tabbar_icon_discover_normal",@"my"];
    NSArray *itemTitles = @[@"报名",@"学车",@"驾考圈",@"我的"];
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    //创建按钮
    for (int i = 0; i < viewCtrl.count; i++) {
        Class class = NSClassFromString(viewCtrl[i]);
        UIViewController *vc = [[class alloc]init];
        vc.title = navTitles[i];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.tabBarItem.title = itemTitles[i];
        nav.tabBarItem.image = [UIImage imageNamed:itemImages[i]];
        [vcs addObject:nav];
    }
    self.viewControllers = vcs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
