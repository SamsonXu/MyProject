//
//  TopicTableView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TopicTableView.h"

@implementation TopicTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style model:(AnswerModel *)model{
    if (self = [super initWithFrame:frame style:style]) {
        self.model = model;
    }
    return self;
}

@end
