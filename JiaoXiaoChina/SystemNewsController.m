//
//  SystemNewsController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "SystemNewsController.h"

@interface SystemNewsController ()

@end

@implementation SystemNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    NSString *imageName;
    NSString *title;
    
    if (self.flag == 0) {
        imageName = @"message_no_content";
        title = @"您当前没有系统消息";
    }else if (self.flag == 1){
        imageName = @"message_no_content";
        title = @"您当前没有回复";
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:imageView];
    KWS(ws);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(ws.view).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 50));
    }];
    
    UILabel *label = [MyControl labelWithTitle:title fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
