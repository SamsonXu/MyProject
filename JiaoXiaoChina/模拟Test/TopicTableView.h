//
//  TopicTableView.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerCell.h"
@interface TopicTableView : UITableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style model:(AnswerModel *)model;

@property (nonatomic, strong) AnswerModel *model;

@end
