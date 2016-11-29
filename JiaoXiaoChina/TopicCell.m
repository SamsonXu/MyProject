//
//  RiderCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TopicCell.h"

@implementation TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(CateModel *)model{
    _model = model;
    _topicImgView.layer.cornerRadius = ((KWidth-30)/4-20)/2;
    _topicImgView.layer.masksToBounds = YES;
    [_topicImgView sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];
    _topicLabel.text = model.name;
}

@end
