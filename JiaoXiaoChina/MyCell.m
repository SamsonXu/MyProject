//
//  MyCell.m
//  MyFamily
//
//  Created by qianfeng on 16/3/18.
//  Copyright (c) 2016年 Motion. All rights reserved.
//

#import "MyCell.h"

@implementation MyCellModel



@end
@implementation MyCell

- (void)awakeFromNib {
}

- (void)setModel:(MyCellModel *)model
{
    _model = model;
    _myCellImageView.image = [UIImage imageNamed:model.image];
    _myCellLabel.text = model.leftTitle;
    _myCellDetailLabel.text = model.rightTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
