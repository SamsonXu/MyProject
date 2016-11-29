//
//  TestRecoderCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/12.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TestRecoderCell.h"

@implementation TestRecoderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(TestRecoderModel *)model{
    _model = model;
    _leftLabel.text = model.score;
    
    _midLabel.text = model.time;
    if (model.score.integerValue >= 90) {
        _rightLabel.text = @"车界大神";
        _rightLabel.textColor = KColorRGB(233, 120, 27);
        _leftLabel.textColor = KColorRGB(233, 120, 27);
    }else{
        _rightLabel.text = @"马路杀手";
        _rightLabel.textColor = [UIColor redColor];
        _leftLabel.textColor = [UIColor redColor];
    }
}
@end
