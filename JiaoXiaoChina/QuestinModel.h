//
//  QuestinModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestinModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;//图片地址
@property (nonatomic, copy) NSString *type;//题库类型
@property (nonatomic, copy) NSString *driveType;//驾照类型
@property (nonatomic, copy) NSString *topicnum;//题目数量
@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, copy) NSString *totlescore;//总分
@property (nonatomic, copy) NSString *passscore;//几个分数
@end
