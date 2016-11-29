//
//  DriveCommentCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DriveCommentCell.h"

@implementation DriveCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(DrivCommentModel *)model{
    _model = model;
    
    _headImgView.layer.cornerRadius = 20;
    _headImgView.layer.masksToBounds = YES;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    
    if (model.nickname.length == 0) {
        _nameLabel.text = @"匿名用户";
    }else{
        _nameLabel.text = model.nickname;
    }
    
    if (model.mobile_phone.length > 0) {
        _phoneLabel.text = [NSString stringWithFormat:@"%@xxxx",[model.mobile_phone substringToIndex:7]];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.integerValue+3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    _timeLabel.text = timeStr;
    
    _commentLabel.text = model.plnr;
    [_starView setStarNum:model.avgnum.floatValue];
}
@end
