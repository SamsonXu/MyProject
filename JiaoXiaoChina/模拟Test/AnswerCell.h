//
//  AnswerCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignModel.h"

@interface AnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic, strong) SignModel *model;

@end
