//
//  RiderCellTwo.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RiderCellTwo.h"
@implementation RiderCellTwo
{
    UIButton *_replyBtn;

    MASConstraint *_bottomReply;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(CommentModel *)model{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    _nameLable.text = model.nickname;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.integerValue+3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    _timeLabel.text = timeStr;
    _topicLabel.text = model.content;
    [_bottomTopic activate];
    [_bottomReply activate];
    _ridersImgsView.hidden = YES;
    [_bottomImage deactivate];
    
    if (model.replaylist.count > 0) {
        _ridComtView.hidden = NO;
        _ridComtView.commentArray = model.replaylist;
        [_bottomComment activate];
        [_bottomReply deactivate];
    }else{
        _ridComtView.hidden = YES;
        [_bottomComment deactivate];
    }
}

- (void)createUI{
    [super createUI];
    [_replyBtn removeFromSuperview];
    
    _replyBtn = [UIButton new];
    [_replyBtn addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_replyBtn];
    
    UIImageView *replyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plblue"]];
    replyView.frame = CGRectMake(40, 0, 20, 20);
    [_replyBtn addSubview:replyView];
    
    UILabel *replyLabel = [MyControl labelWithTitle:@"回复" fram:CGRectMake(0, 0, 40, 20) color:KColorSystem fontOfSize:14 numberOfLine:1];
    [_replyBtn addSubview:replyLabel];
    
    [_topicLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView);
        make.top.equalTo(_iconView.mas_bottom).offset(10);
        make.width.mas_equalTo(KWidth-20);
        _bottomTopic = make.bottom.equalTo(_replyBtn.mas_top).offset(-10).priority(UILayoutPriorityDefaultHigh);
        [_bottomTopic deactivate];
    }];
    
    _ridersImgsView = [[RidersImagesView alloc]init];
    [_bgView addSubview:_ridersImgsView];
    [_ridersImgsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topicLabel.mas_bottom).offset(10);
        make.left.width.equalTo(_topicLabel);
        _bottomImage = make.bottom.equalTo(_timeLabel.mas_top).offset(-10).priority(UILayoutPriorityDefaultHigh);
        [_bottomImage deactivate];
    }];
    
    [_replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        _bottomReply = make.bottom.equalTo(_bgView).offset(-10).priority(UILayoutPriorityDefaultHigh);
        [_bottomReply deactivate];
    }];
    
    _ridComtView = [[RidersCommentView alloc]init];
    [_bgView addSubview:_ridComtView];
    [_ridComtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_replyBtn.mas_bottom).offset(10);
        make.left.right.equalTo(_topicLabel);
        _bottomComment = make.bottom.equalTo(_bgView).offset(-10).priority(UILayoutPriorityDefaultHigh);
        [_bottomComment deactivate];
    }];
}

- (void)replyClick:(UIButton *)btn{
    [self.delegate replyWithModel:_model];
}

@end
