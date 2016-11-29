//
//  ClassCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell

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
    
    _applyLabel.layer.borderColor = KColorSystem.CGColor;
    _applyLabel.layer.borderWidth = 1;
    _applyLabel.layer.cornerRadius = 5;
    _titleLabel.text = model.title;
    _yufuLabel.text = [NSString stringWithFormat:@"首付%@",model.yufujin];
    
    if (model.label_str.length > 0) {
        NSArray *siagns = [model.label_str componentsSeparatedByString:@","];
        if (siagns.count == 0) {
            _sign1Label.text = model.label_str;
        }else if (siagns.count == 1){
            _sign1Label.text = siagns[0];
        }else{
            _sign1Label.text = siagns[0];
            _sign2Label.text = siagns[1];
        }
    }
    
    _oneadLabel.text = model.onead;
    _priceLabel.text = model.pric;
    _jiageLabel.text = [NSString stringWithFormat:@"市场价 ¥%@",model.jiage];
    _driveLabel.text = model.cheben_arr;
    
}
@end
