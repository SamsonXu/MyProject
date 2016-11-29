//
//  JournalCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JournalCell.h"

@implementation JournalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JournalModel *)model{
    _model = model;
    
    _bordView.layer.borderWidth = 1;
    _bordView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    _topicLabel.text = model.title;
    _titleLabel.text = model.wdnr;
    _favoriteLabel.text = model.praise;
    _commentLabel.text = model.replynum;
    _titleLabel.text = model.wenda_cate_name;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.integerValue+3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    _timeLabel.text = timeStr;
    
    if (_model.is_zan.integerValue == 1) {
        _favoriteBtn.selected = YES;
        _favoriteImgView.image = [UIImage imageNamed:@"zhan-h"];
    }
}


- (IBAction)favoriteBtn:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _favoriteImgView.image = [UIImage imageNamed:@"zhan"];
        _favoriteLabel.text = [NSString stringWithFormat:@"%ld",_favoriteLabel.text.integerValue-1];
        [self.delegate changFavoriteNum:NO pid:_model.pid];
    }else{
        sender.selected = YES;
        _favoriteImgView.image = [UIImage imageNamed:@"zhan-h"];
        _favoriteLabel.text = [NSString stringWithFormat:@"%ld",_favoriteLabel.text.integerValue+1];
        [self.delegate changFavoriteNum:YES pid:_model.pid];
    }
}

- (IBAction)commentBtn:(UIButton *)sender {
    
}
@end
