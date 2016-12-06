//
//  OrderCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/21.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OrderModel *)model{
    _model = model;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.integerValue+3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    _timeLabel.text = timeStr;
    
    _payBtn.layer.cornerRadius = 5;
    _payBtn.layer.masksToBounds = YES;
    
    if (_model.is_expire.integerValue == 1) {
        _payBtn.backgroundColor = [UIColor lightGrayColor];
    }else{
        _payBtn.backgroundColor = KColorSystem;
    }
    
    _cityLabel.text = model.cityname;
    _driveLabel.text = model.dname;
    _classLabel.text = model.title;
    _chebenLabel.text = model.cheben_arr;
    _priceLabel.text = [NSString stringWithFormat:@"需支付%@元",model.count_price];
    
    if (model.payment_type.integerValue == 2) {
        _typeLabel.text = @"待支付首款";
    }else if (model.payment_type.integerValue == 1){
        _typeLabel.text = @"待支付全款";
    }
    
}

- (IBAction)payBtn:(UIButton *)sender {
    if (_model.is_expire.integerValue == 1) {
        return;
    }else{
        [self.delegate pushToPayViewCtrl:_model];
    }
    
}
@end
