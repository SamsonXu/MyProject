//
//  RiderCellOne.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RiderCellOne.h"

@implementation RiderCellOne
{
    UILabel *_contentLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(JournalModel *)model{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    _nameLable.text = model.nickname;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.integerValue+3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    _timeLabel.text = timeStr;

    if (model.city.length > 0) {
        _cityLabel.text = [NSString stringWithFormat:@"来自  %@",model.city];
    }
    if (model.title.length > 0) {
        _topicLabel.text = model.title;
    }
    if (model.wenda_cate_name.length > 0) {
        _contentLabel.text = model.wdnr;
    }
    _typeLabel.text = model.wenda_cate_name;
    _favoLabel.text = model.praise;
    _comLabel.text = model.replynum;
    
    if (_model.is_zan.integerValue == 1) {
        _favoBtn.selected = YES;
        _favoView.image = [UIImage imageNamed:@"zhan-h"];
    }else if (_model.is_zan.integerValue == 0){
        _favoBtn.selected = NO;
        _favoView.image = [UIImage imageNamed:@"zhan"];
    }
    
    [_bottomTopic activate];
    [_bottomContent activate];
    if (model.imglist.count > 0) {
        _ridersImgsView.hidden = NO;
        _ridersImgsView.images = model.imglist;
        [_bottomTopic deactivate];
        [_bottomContent deactivate];
        [_bottomImage activate];
    }else{
        _ridersImgsView.hidden = YES;
        [_bottomImage deactivate];
    }
    
}

- (void)createUI{
    [super createUI];
        _contentLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:0];
        _contentLabel.lineBreakMode=NSLineBreakByCharWrapping;
        [_bgView addSubview:_contentLabel];
    
        _typeLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
        [_bgView addSubview:_typeLabel];
    
        _favoBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:nil];
        [_favoBtn addTarget:self action:@selector(favoBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_favoBtn];
    
        _favoView = [MyControl imageViewWithFram:CGRectMake(0, 0, 20, 20) imageName:@"zhan"];
        [_favoBtn addSubview:_favoView];
    
        _favoLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(25, 0, 35, 20) color:[UIColor grayColor] fontOfSize:12 numberOfLine:1];
        [_favoBtn addSubview:_favoLabel];
    
        _comBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:nil];
        [_bgView addSubview:_comBtn];
    
        _comView = [MyControl imageViewWithFram:CGRectMake(0, 0, 20, 20) imageName:@"pl"];
        [_comBtn addSubview:_comView];
    
        _comLabel = [MyControl labelWithTitle:@"" fram:CGRectMake(25, 0, 35, 20) color:[UIColor grayColor] fontOfSize:12 numberOfLine:1];
        [_comBtn addSubview:_comLabel];
    
        [_topicLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView);
            make.top.equalTo(_iconView.mas_bottom).offset(10);
            make.width.mas_equalTo(KWidth-20);
        }];
    
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topicLabel.mas_bottom).offset(10);
            make.left.width.equalTo(_topicLabel);
            
            _bottomContent = make.bottom.equalTo(_typeLabel.mas_top).offset(-10).priority(UILayoutPriorityDefaultHigh);
            [_bottomContent deactivate];
        }];

        _ridersImgsView = [[RidersImagesView alloc]init];
        [_bgView addSubview:_ridersImgsView];
        [_ridersImgsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topicLabel.mas_bottom).offset(10);
            make.left.width.equalTo(_topicLabel);
            _bottomImage = make.bottom.equalTo(_typeLabel.mas_top).offset(-10).priority(UILayoutPriorityDefaultHigh);
            [_bottomImage deactivate];
        }];
    
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topicLabel);
            make.height.mas_equalTo(20);
            _bottomType = make.bottom.equalTo(_bgView).offset(-10).priority(UILayoutPriorityDefaultHigh);
            [_bottomType deactivate];
        }];
    
        [_comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_typeLabel);
            make.right.equalTo(_bgView);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(60);
        }];
    
        [_favoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_typeLabel);
            make.right.equalTo(_comBtn.mas_left);
            make.height.width.equalTo(_comBtn);
        }];

}

- (void)favoBtn:(UIButton *)sender{
    if (![DefaultManager getValueOfKey:@"token"]) {
        [self.delegate gotoLogin];
        return;
    }
    
    if (sender.selected) {
        sender.selected = NO;
        _favoView.image = [UIImage imageNamed:@"zhan"];
        _favoLabel.text = [NSString stringWithFormat:@"%ld",_favoLabel.text.integerValue-1];
        [self.delegate changFavoriteNum:NO pid:_model.pid];
    }else{
        sender.selected = YES;
        _favoView.image = [UIImage imageNamed:@"zhan-h"];
        _favoLabel.text = [NSString stringWithFormat:@"%ld",_favoLabel.text.integerValue+1];
        [self.delegate changFavoriteNum:YES pid:_model.pid];
    }
}

@end
