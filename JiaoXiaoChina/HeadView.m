//
//  HeadView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame model:(ClassModel *)model{
    if (self = [super initWithFrame:frame]) {
        [self creatViewWithModel:model];
    }
    return self;
}

- (void)creatViewWithModel:(ClassModel *)model{
    
    KWS(ws);
    self.backgroundColor = [UIColor whiteColor];
    UILabel *classLabel = [MyControl labelWithTitle:model.title fram:CGRectMake(0, 0, 0, 0) fontOfSize:16];
    [self addSubview:classLabel];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *cbLabel = [MyControl labelWithTitle:model.cheben_arr fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [self addSubview:cbLabel];
    [cbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(classLabel);
        make.left.equalTo(classLabel.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *driveLabel = [MyControl labelWithTitle:model.dname fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [self addSubview:driveLabel];
    [driveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(classLabel);
        make.left.equalTo(cbLabel.mas_right).offset(20);
    }];
    
    UILabel *priceLabel = [MyControl labelWithTitle:model.pric fram:CGRectMake(0, 0, 0, 0) color:KColorSystem fontOfSize:17 numberOfLine:1];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(classLabel);
        make.right.equalTo(ws).offset(-10);
    }];
    
    UILabel *rightLabel = [MyControl labelWithTitle:[NSString stringWithFormat:@"首付 ￥"] fram:CGRectMake(0, 0, 0, 0) color:KColorSystem fontOfSize:12 numberOfLine:1];
    [self addSubview:rightLabel];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLabel.mas_left).offset(-5);
        make.centerY.height.equalTo(classLabel);
    }];
    
    if (model.is_payment_type.integerValue != 2) {
        rightLabel.text = @"费用 ￥";
    }
    
    UILabel *botomLabel = [MyControl labelWithTitle:@"现金券可抵用" fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:12 numberOfLine:1];
    botomLabel.textAlignment = NSTextAlignmentCenter;
    botomLabel.backgroundColor = KColorSystem;
    [self addSubview:botomLabel];
    
    [botomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(classLabel);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.top.equalTo(classLabel.mas_bottom).offset(10);
    }];

}

@end
