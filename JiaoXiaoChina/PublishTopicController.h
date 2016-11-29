//
//  PublishTopicController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@interface PublishTopicController : RootViewController

@property (nonatomic, copy) NSString *pid;//日志类型id
@property (nonatomic, copy) NSString *topicName;//类型名称
@property (nonatomic, copy) NSString *topicId;//类型id
@property (nonatomic, assign) BOOL isJournal;//是否为日志
@property (nonatomic, assign) BOOL isTopic;//是否为话题
@end
