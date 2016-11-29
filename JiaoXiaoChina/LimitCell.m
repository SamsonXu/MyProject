//
//  LimitCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "LimitCell.h"

@implementation LimitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ClassModel *)model{
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.dbimg] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text = model.title;
    _driveLabel.text = model.cheben_arr;
    _signLabel.text = model.label_kecheng;
    _priceLabel.text = model.pric;
    _jiageLabel.text = [NSString stringWithFormat:@"市场价 ￥%@",model.jiage];
    _schoolLabel.text = model.dname;
    
    NSString *str = [model.Distance componentsSeparatedByString:@"."][0];
    if (str.length < 4) {
        str = [NSString stringWithFormat:@"%@mj",str];
    }else{
        str = [NSString stringWithFormat:@"%.1lfkm",str.floatValue/1000];
    }
    _distanceLabel.text = [NSString stringWithFormat:@"最近训练场 %@",str];
}
@end
