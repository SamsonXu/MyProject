//
//  DetailCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/18.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DetailCell.h"

@interface DetailCell ()
{
    
}
@end

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(JournalModel *)model{
    _model = model;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.integerValue+3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    _timeLabel.text = timeStr;
    
    _topicLabel.text = model.title;
    _topicDetailLabel.text = model.wdnr;
    _locatLabel.text = model.city;
    _typeLabel.text = model.wenda_cate_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
