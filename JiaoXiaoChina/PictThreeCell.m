//
//  PictThreeCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictThreeCell.h"

@implementation PictThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SignModel *)model{
    _model = model;
    _bigImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.imageurl]];
    _titleLabel.text = model.title;
    _descLabel.text = model.desc;
    
}
@end
