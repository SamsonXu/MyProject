//
//  RidersCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RidersCell.h"

@implementation RidersCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}


- (void)createUI{
    KWS(ws);
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    [_bgView addSubview:_iconView];
    
    _nameLable = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [_bgView addSubview:_nameLable];
    
    _contentLabel = [MyControl labelWithTitle:@"label" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:0];
    _contentLabel.lineBreakMode=NSLineBreakByCharWrapping;
    [_bgView addSubview:_contentLabel];
    
    _timeLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [_bgView addSubview:_timeLabel];
    
    _cityLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [_bgView addSubview:_cityLabel];
    
    _topicLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    _topicLabel.numberOfLines = 0;
    [_bgView addSubview:_topicLabel];

    
    [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_bgView).offset(10);
        make.height.width.mas_equalTo(40);
    }];
    
    
    [_nameLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView);
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(5);
        make.left.equalTo(_nameLable);
        make.height.mas_equalTo(20);
    }];
    
    [_cityLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.left.equalTo(_timeLabel.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];

}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
