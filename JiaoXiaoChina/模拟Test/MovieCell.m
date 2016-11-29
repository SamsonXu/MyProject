//
//  MovieCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(MovieModel *)model{
    _model = model;
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"jxzg_bg"]];
    _movieLabel.text = model.title;
}

@end
