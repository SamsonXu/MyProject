//
//  ClassDetailController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ClassDetailController.h"
#import "ConsultViewController.h"
@interface ClassDetailController ()

@end

@implementation ClassDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    [super createUI];
    self.title = @"班型详情";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.frame = CGRectMake(0, KScreenHeight-50, 80, 50);
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"telephone"]];
            [btn addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn).offset(10);
                make.centerX.equalTo(btn);
                make.height.width.mas_equalTo(20);
            }];
            
            UILabel *label = [MyControl labelWithTitle:@"电话" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
            label.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.bottom.width.equalTo(btn);
                make.height.mas_equalTo(20);
            }];
            
        }else if (i == 1){
            
            btn.frame = CGRectMake(80, KScreenHeight-50, KScreenWidth-80, 50);
            btn.backgroundColor = KColorSystem;
            [btn setTitle:@"我要报名" forState:UIControlStateNormal];

        }
        [self.view addSubview:btn];
    }
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-50)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&longitude=%@&latitude=%@",KUrlClassDetail,_model.pid,_longitude,_latitude]]]];
    [self.view addSubview:webView];
}

- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 100) {
        [self showAlertViewWith:@[@"咨询驾校中国专属学车顾问",[NSString stringWithFormat:@"%@",_model.tel],@"取消",@"确定"] sel:@selector(telephone)];
        
    }else if (btn.tag == 101){

            ConsultViewController *vc = [[ConsultViewController alloc]init];
            vc.model = _model;
            [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)telephone{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.tel]]];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    KWS(ws);
    NSString *url;
    [MyControl UMSocialWithTitle:_model.dname url:url ws:ws];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
