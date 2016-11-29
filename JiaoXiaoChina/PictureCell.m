//
//  PictureCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictureCell.h"
@implementation PictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(PicModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _numberLabel.text = [NSString stringWithFormat:@"%@张",model.num];
    _firstImage.image = [UIImage imageNamed:model.images[0]];
    _secondImage.image = [UIImage imageNamed:model.images[1]];
    _thirdImage.image = [UIImage imageNamed:model.images[2]];
    _fouthImage.image = [UIImage imageNamed:model.images[3]];
}
@end
