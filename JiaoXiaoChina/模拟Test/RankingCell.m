//
//  RankingCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(RankModel *)model{
    _model = model;
    _headImgView.layer.cornerRadius = 25;
    _headImgView.layer.masksToBounds = YES;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    if (model.nickname.length == 0) {
        _nameLabel.text = @"匿名用户";
    }else{
        _nameLabel.text = model.nickname;
    }
    NSString *imgStr;
    if (model.sex.integerValue == 1) {
        imgStr = @"user_sex_male";
    }else if (model.sex.integerValue == 2){
        imgStr = @"user_sex_female";
    }
    _sexImgView.image = [UIImage imageNamed:imgStr];
    _scoreLabel.text = [NSString stringWithFormat:@"%@分",model.fenshu];
    _timeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",model.kstime.integerValue/60,model.kstime.integerValue%60];
}
@end
