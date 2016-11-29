//
//  LimitSale.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "LimitSaleView.h"

@implementation LimitSaleView

-(instancetype)initWithFrame:(CGRect)frame model:(ClassModel *)model time:(NSString *)time{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self createViewWithTime:time];
    }
    return self;
}

- (void)createViewWithTime:(NSString *)time{
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIImageView *imgView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xsyhleft"]];
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(imgView1).offset(10);
        make.size.mas_equalTo(CGSizeMake(21, 20));
    }];
    [topView addSubview:imgView1];
    
    UIImageView *imgView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xsyh"]];
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(imgView1.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(84, 20));
    }];
    [topView addSubview:imgView2];
    
    UIImageView *imgView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yharrow"]];
    [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(11, 20));
    }];
    [topView addSubview:imgView3];
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 31, KWidth, KHeight-31)];
    subView.backgroundColor = [UIColor whiteColor];
    [self addSubview:subView];
    
    UIImageView *iconView = [UIImageView new];
    [iconView sd_setImageWithURL:[NSURL URLWithString:_model.kcimg] placeholderImage:[UIImage imageNamed:@"jxzg_bg"]];
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(subView).offset(10);
        make.size.mas_equalTo(CGSizeMake(140, 110));
    }];

    UILabel *applyLabel = [MyControl labelWithTitle:[NSString stringWithFormat:@"已有人报名"] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    applyLabel.textColor = [UIColor whiteColor];
    applyLabel.textAlignment = NSTextAlignmentCenter;
    applyLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    [iconView addSubview:applyLabel];
    [iconView bringSubviewToFront:applyLabel];
    [applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(iconView);
        make.height.mas_equalTo(20);
    }];

    UILabel *limitLabel = [MyControl boldLabelWithTitle:@"限量抢" fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17];
    limitLabel.backgroundColor = KColorSystem;
    limitLabel.layer.cornerRadius = 5;
    limitLabel.layer.masksToBounds = YES;
    limitLabel.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(10);
        make.left.equalTo(iconView);
        make.size.mas_equalTo(CGSizeMake(KWidth-20, 30));
    }];

    UILabel *minLabel = [MyControl labelWithTitle:@"¥" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    minLabel.textColor = KColorSystem;
    [self addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10);
        make.height.width.mas_equalTo(10);
    }];
    
    UILabel *priceLabel = [MyControl labelWithTitle:_model.pric fram:CGRectMake(0, 0, 0, 0) fontOfSize:24];
    priceLabel.textColor = KColorSystem;
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView).offset(10);
        make.left.equalTo(minLabel.mas_right).offset(5);
        make.bottom.equalTo(minLabel);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *jiageLabel = [MyControl labelWithTitle:[NSString stringWithFormat:@"市场价 ￥%@",_model.jiage] fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [self addSubview:jiageLabel];
    [jiageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minLabel);
        make.top.equalTo(priceLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = [UIColor grayColor];
    [jiageLabel addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(jiageLabel);
        make.width.equalTo(jiageLabel);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *sign1Label = [MyControl labelWithTitle:_model.labelids fram:CGRectMake(0, 0, 0, 0) fontOfSize:16];
    sign1Label.backgroundColor = KColorSystem;
    [subView addSubview:sign1Label];
    [sign1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minLabel);
        make.top.equalTo(jiageLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];

    UILabel *endLabel = [MyControl labelWithTitle:@"距离结束" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [subView addSubview:endLabel];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minLabel);
        make.top.equalTo(sign1Label.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];

    UILabel *lastLabel = nil;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue+3600*8];
    NSDate *date2 = [NSDate date];
    _inte = [date timeIntervalSinceDate:date2];
    NSArray *array = @[[NSString stringWithFormat:@"%ld",(NSInteger)_inte/3600],[NSString stringWithFormat:@"%ld",(NSInteger)_inte%3600/60],[NSString stringWithFormat:@"%ld",(NSInteger)_inte%3600%60]];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [MyControl labelWithTitle:array[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        label.tag = 100+i;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = KColorSystem;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [subView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(endLabel);
            if (lastLabel) {
                make.left.equalTo(lastLabel.mas_right).offset(10);
            }else{
                make.left.equalTo(endLabel.mas_right).offset(10);
            }
            make.height.width.mas_equalTo(20);
        }];
        
        if (i < 2) {
            UILabel *label1 = [MyControl labelWithTitle:@":" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
            label1.textAlignment = NSTextAlignmentCenter;
            [subView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label);
                make.left.equalTo(label.mas_right);
                make.size.mas_equalTo(CGSizeMake(10, 20));
            }];
        }
        
        
        lastLabel = label;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
}

- (void)reduceTime{
    
    if (_inte == 0) {
        [_timer invalidate];
        return;
    }
    _inte--;
    
    NSArray *array = @[[NSString stringWithFormat:@"%ld",(NSInteger)_inte/3600],[NSString stringWithFormat:@"%ld",(NSInteger)_inte%3600/60],[NSString stringWithFormat:@"%ld",(NSInteger)_inte%3600%60]];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [self viewWithTag:100+i];
        label.text = array[i];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate doPushWithTime:_inte];
}
@end
