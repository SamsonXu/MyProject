//
//  TestView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TestView.h"

@implementation TestView

-(instancetype)initWithFrame:(CGRect)frame flag:(NSInteger)flag{
    if (self = [super initWithFrame:frame]) {
        _flag = flag;
        [self createViewWithFlag:flag];
    }
    return self;
}

//创建视图
- (void)createViewWithFlag:(NSInteger)flag{
    //图片和标题数组
    NSArray *images1 = @[@"driving_suiji",@"driving_zhuanxiang",@"driving_yicuo",@"remember_mode_h"];
    NSArray *titles1 = @[@"随机练习",@"专项练习",@"易错题集",@"未做题"];
    NSArray *images2 = @[@"driving_jilu",@"driving_paihang",@"remember_mode_h",@"driving_xuyuan"];
    NSArray *titles2 = @[@"考试记录",@"成绩排行",@"考试统计",@"考前许愿"];
    NSArray *images = [NSArray new];
    NSArray *titles = [NSArray new];
    //中间按钮
    UIButton *midBtn = [UIButton new];
    midBtn.tag = 104;
    [self addSubview:midBtn];
    //中间label
    UILabel *midLabel = [MyControl labelWithTitle:nil fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17 numberOfLine:1];
    midLabel.textAlignment = NSTextAlignmentCenter;
    KWS(ws);
    if (flag == 1) {
        images = images1;
        titles = titles1;
        midBtn.backgroundColor = KColorRGB(115, 193, 0);
        midBtn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        midBtn.layer.borderWidth = 5;
        midLabel.text = @"顺序练习";
    }else if(flag == 2){
        images = images2;
        titles = titles2;
        midBtn.backgroundColor = KColorRGB(19, 153, 229);
        midBtn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.6].CGColor;
        midBtn.layer.borderWidth = 5;
        midLabel.text = @"模拟考试";
    }
    [midBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    midBtn.layer.cornerRadius = 50;
    [self addSubview:midBtn];
    [midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.height.width.mas_equalTo(100);
    }];
    [midBtn addSubview:midLabel];
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(midBtn);
        make.height.mas_equalTo(20);
    }];
    
    //周围4个按钮
    UIButton *lastBtn = [UIButton new];
    lastBtn = nil;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        KWS(ws);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%2 == 0) {
                make.left.equalTo(ws);
            }else{
                make.left.equalTo(lastBtn.mas_right).offset(1);
            }
            if (i <= 1) {
                make.top.equalTo(ws);
            }else if(i < 3){
                make.top.equalTo(lastBtn.mas_bottom).offset(1);
            }else{
                make.top.equalTo(lastBtn);
            }
            make.height.mas_equalTo(70);
            CGFloat width = (self.frame.size.width-1)/2;
            make.width.mas_equalTo(width);
        }];
        //按钮图片
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        //标题
        UILabel *titleLabel = [MyControl labelWithTitle:titles[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
        }];
        lastBtn = btn;
        
    }
    [self bringSubviewToFront:midBtn];
}

- (void)btnClick:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    [self.delegate testViewWithtag:index flag:_flag];
}

@end
