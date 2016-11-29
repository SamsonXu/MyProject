//
//  CashCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "CashCell.h"

@implementation CashCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(CashModel *)model{
    
    _model = model;
    _PriceLabel.text = model.price;
    _titleLabel.text = model.title;
    _endLabel.text = [NSString stringWithFormat:@"有效期至 %@",model.str_end_time];
    
    if (model.is_expire.integerValue == 1) {
        _stateLabel.text = @"已过期";
    }else if (model.is_use.integerValue == 0) {
        _stateLabel.text = @"未使用";
    }else{
        _stateLabel.text = @"已使用";
    }
    _areaLabel.text = model.str_area;
}

@end
