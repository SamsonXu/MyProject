//
//  ManagerCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ManagerCell.h"

@implementation ManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(MovieModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _downLoadLabel.text = @"未下载";
    _ramLabel.text = model.time;
}

@end
