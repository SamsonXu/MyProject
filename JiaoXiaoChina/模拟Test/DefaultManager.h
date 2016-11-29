//
//  QuestionManager.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/10.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultManager : NSObject
//获得错题
+ (NSArray *)getWrongQuestion;
//添加错题
+ (void)addWrongQuestion:(int)pid;
//删除错题
+ (void)removeWrongQuestion:(int)pid;

//获得收藏
+ (NSArray *)getCollectQuestion;
//收藏题目
+ (void)addCollectQuestion:(int)pid;
//删除本题
+ (void)removeCollectQuestion:(int)pid;

//创建未做题数组
+ (void)createQuestionBase;
//获得未做题
+ (NSArray *)getQuestionBase;
//删除未做题
+ (void)removeDidQuestion:(int)pid;

//添加成绩
+ (void)addScoreRecoderWithScore:(NSInteger )score time:(NSString *)time flag:(NSInteger)flag num:(NSInteger)num;
//删除成绩
+ (void)removeScoreRecoderWithScore:(NSInteger)score time:(NSString *)timeStr;
//获取成绩
+ (NSInteger)getBestScore;

//存入数据
+ (void)addValue:(NSString *)value key:(NSString *)key;
//取得数据
+ (NSString *)getValueOfKey:(NSString *)key;
//删除数据
+ (void)removeValueOfKey:(NSString *)key;

@end
