//
//  PictTwoCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictTwoCell.h"

@implementation PictTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SignModel *)model{
    _model = model;
    _itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.imageurl]];
    _itemLabel.text = model.title;
}

@end
