//
//  ListCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/1.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(ListModel *)model{
    _model = model;
    [_listImageView sd_setImageWithURL:[NSURL URLWithString:model.title_img] placeholderImage:[UIImage imageNamed:@"jxzg_bg"]];
    _listTitleLabel.text = model.title;
    _listReadLabel.text = [NSString stringWithFormat:@"阅读:%@",model.click_count];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.update_time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    _listTimeLabel.text = [formatter stringFromDate:date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
