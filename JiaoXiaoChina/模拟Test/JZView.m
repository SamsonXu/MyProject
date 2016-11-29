//
//  JZView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/27.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JZView.h"

@implementation JZView

-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        [self createViewWithimage:imageName titles:titles];
    }
    return self;
}

//创建视图
- (void)createViewWithimage:(NSString *)imageName titles:(NSArray *)titles{
    //头部视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headView];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(headView).offset(10);
        make.height.width.mas_equalTo(20);
    }];
    UILabel *headLabel = [MyControl labelWithTitle:titles[0] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14 numberOfLine:1];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.centerY.height.equalTo(imageView);
    }];
    
    //下面4个按钮
    UIButton *lastBtn = [UIButton new];
    lastBtn = nil;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titles[i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
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
                make.top.equalTo(headView.mas_bottom).offset(1);
            }else if(i < 3){
                make.top.equalTo(lastBtn.mas_bottom).offset(1);
            }else{
                make.top.equalTo(lastBtn);
            }
            make.height.mas_equalTo(50);
            CGFloat width = (self.frame.size.width-1)/2;
            make.width.mas_equalTo(width);
        }];
        lastBtn = btn;
    }
    
}
- (void)btnClick:(UIButton *)btn{
    [self.delegate pushWithTag:btn.tag-100 flag:_flag];
}

@end
