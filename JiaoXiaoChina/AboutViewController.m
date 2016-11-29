//
//  AboutViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI{
    self.title = @"关于我们";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
