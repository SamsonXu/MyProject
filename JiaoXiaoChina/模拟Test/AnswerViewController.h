//
//  AnswerViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@protocol AnswerProtocol <NSObject>

- (void)passValue:(NSInteger)num;

@end
@interface AnswerViewController : RootViewController

@property (nonatomic, assign) NSInteger number;//科目类型
@property (nonatomic, assign) NSInteger fl;//题型
@property (nonatomic, assign) NSInteger zj;//章节
@property (nonatomic, strong) NSMutableArray *modelArr;//题目数据源
@property (nonatomic, weak) id<AnswerProtocol>delegate;
//type=1 随机 type=2 章节 type=3易错 type=4未做 type=5顺序练习 type=6全真模拟考试 type=7 优先考未做题 type=8 我的错题 type=9 我的收藏 type=10题型
@property (nonatomic, assign) int type;
//自动移除错题
@property (nonatomic, assign) BOOL remove;
//考试题目数
@property (nonatomic ,assign) NSInteger topicNum;

@end
