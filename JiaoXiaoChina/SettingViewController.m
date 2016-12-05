//
//  SettingViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "SettingViewController.h"
#import "MyCell.h"
#import "FeedBackViewController.h"
#import "LeftScrollViewController.h"
#import "WebViewController.h"
#define KImage @"image"
#define KTitle @"title"
#define KDetail @"detail"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    
    self.title = @"设置";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    _tableView.backgroundColor = KGrayColor;
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 300, KScreenWidth, 40) title:@"退出登录" imageName:nil];
    btn.backgroundColor = [UIColor whiteColor];
    if (!self.hasLogin) {
        btn.hidden = YES;
    }
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:btn];
}

- (void)requestData{
    
    NSArray *array = @[@{KImage:@"feedback",KTitle:@"意见反馈",KDetail:@""},@{KImage:@"userplan",KTitle:@"用户协议",KDetail:@""},@{KImage:@"aboutus",KTitle:@"关于驾校中国",KDetail:@""},@{KImage:@"delcookie",KTitle:@"清除缓存",KDetail:@""}];
    for (NSDictionary *dict in array) {
        MyCellModel *model = [[MyCellModel alloc]init];
        model.image = dict[KImage];
        model.leftTitle = dict[KTitle];
        model.rightTitle = dict[KDetail];
        [_dataArray addObject:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide = @"myCell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    if (index == 0) {
        FeedBackViewController *vc = [[FeedBackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 1){
        WebViewController *vc = [[WebViewController alloc]init];
        vc.navTitle = @"用户协议";
        vc.url = @"";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 2){
        WebViewController *vc = [[WebViewController alloc]init];
        vc.navTitle = @"关于驾校中国";
        vc.url = KUrlAboutUs;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 3){
        [MBProgressHUD showMessage:@"正在清除缓存"];
        [MyControl cancelWebCache];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"清理成功"];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)btnClick:(UIButton *)btn{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn.hidden = YES;
        [DefaultManager removeValueOfKey:@"token"];
        [DefaultManager removeValueOfKey:@"userInfo"];
        [DefaultManager removeValueOfKey:KTrueFaults];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logoff" object:nil];
        
    }];
    [alertCtrl addAction:action1];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
}

- (void)leftClick:(UIButton *)btn{
        [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
