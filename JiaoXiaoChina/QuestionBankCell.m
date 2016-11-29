//
//  QuestionBankCell.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "QuestionBankCell.h"

@implementation QuestionBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(QuestinModel *)model{
    
    _iconImageView.image = [UIImage imageNamed:model.imageUrl];
    _typeLabel.text = model.type;
    _driveLabel.text = model.driveType;
}

@end
