//
//  ApplyCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ApplyCell.h"

@implementation ApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ApplyModel *)model{
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.dbimg] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text = model.dname;
    
    NSString *str = [model.Distance componentsSeparatedByString:@"."][0];
    if (str.length < 4) {
        str = [NSString stringWithFormat:@"%@m",str];
    }else{
        str = [NSString stringWithFormat:@"%.1lfkm",str.floatValue/1000];
    }
    _distanceLabel.text = str;
    
    [_starView setStarNum:model.score.floatValue];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
    NSString *areaStr;
    
    for (NSDictionary *dict in array) {
        if ([model.city isEqualToString:dict[@"id"]]) {
            NSArray *areaArr = dict[@"areadata"];
            for (NSDictionary *areaDict in areaArr) {
                if ([model.county isEqualToString:areaDict[@"id"]]) {
                    areaStr = areaDict[@"areaname"];
                }
            }
        }
    }
    _areaLabel.text = areaStr;
    
    _countLabel.text = [NSString stringWithFormat:@"已有%@人报名",model.order_num];
}
@end
