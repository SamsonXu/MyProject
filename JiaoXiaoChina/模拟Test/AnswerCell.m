//
//  AnswerCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(SignModel *)model{
    _model = model;
    _iconImageView.hidden = NO;
    _iconImageView.frame = CGRectMake(10, 10, 40, 40);
    _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.image]];
    _mainLabel.text = model.title;
    _rightLabel.text = [NSString stringWithFormat:@"%@张",model.bcount];
}
@end
