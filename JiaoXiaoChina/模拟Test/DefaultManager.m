//
//  QuestionManager.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/10.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DefaultManager.h"
#import "AnswerModel.h"
@implementation DefaultManager

+ (NSArray *)getWrongQuestion{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KWrong];
    if (array != nil) {
        return array;
    }else{
        return nil;
    }
}

+ (void)addWrongQuestion:(int)pid{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KWrong];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    for (NSString *str in muArr) {
        if (str.integerValue == pid) {
            return;
        }
    }
    [muArr addObject:[NSString stringWithFormat:@"%d",pid]];
    [[NSUserDefaults standardUserDefaults]setObject:muArr forKey:KWrong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)removeWrongQuestion:(int)pid{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KWrong];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    for (int i = (int)muArr.count-1; i >= 0; i--) {
        if ([muArr[i] integerValue] == pid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:muArr forKey:KWrong];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSArray *)getCollectQuestion{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KCollect];
    if (array != nil) {
        return array;
    }else{
        return nil;
    }
}

+ (void)addCollectQuestion:(int)pid{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KCollect];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    [muArr addObject:[NSString stringWithFormat:@"%d",pid]];
    [[NSUserDefaults standardUserDefaults]setObject:muArr forKey:KCollect];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)removeCollectQuestion:(int)pid{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KCollect];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    for (int i = (int)muArr.count-1; i >= 0; i--) {
        if ([muArr[i] integerValue] == pid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:muArr forKey:KCollect];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)createQuestionBase{
    NSMutableArray *mulArr = [[NSMutableArray alloc]init];
    NSArray *array = [[DBManager shareManager]selectDataWithCb:[[DefaultManager getValueOfKey:KJZLX]integerValue]];
    for (AnswerModel *model in array) {
        NSString *str = [NSString stringWithFormat:@"%d",model.pid];
        [mulArr addObject:str];
    }
    [[NSUserDefaults standardUserDefaults]setObject:mulArr forKey:KQuesBase];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSArray *)getQuestionBase{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KQuesBase];
    if (array != nil) {
        return array;
    }else{
        return nil;
    }
}

+ (void)removeDidQuestion:(int)pid{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KQuesBase];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    for (int i = (int)muArr.count-1; i >= 0; i--) {
        if ([muArr[i] integerValue] == pid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:muArr forKey:KQuesBase];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)addScoreRecoderWithScore:(NSInteger )score time:(NSString *)timeStr flag:(NSInteger)flag num:(NSInteger)num{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[defaults objectForKey:KScores]];
    [array addObject:@{@"score":[NSString stringWithFormat:@"%ld",score],@"time":timeStr,@"flag":[NSString stringWithFormat:@"%ld",flag],@"num":[NSString stringWithFormat:@"%ld",num]}];
    [defaults setObject:array forKey:KScores];
    [defaults synchronize];
}

+ (void)removeScoreRecoderWithScore:(NSInteger)score time:(NSString *)timeStr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:KScores];
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        if ([dict[@"score"] integerValue] == score && [dict[@"time"] isEqualToString:timeStr]) {
            [array1 removeObject:dict];
        }
    }
    [defaults setObject:array1 forKey:KScores];
    [defaults synchronize];
}

+ (NSInteger)getBestScore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSMutableArray *array = [defaults objectForKey:KScores];
    if (array.count == 0) {
        return 101;
    }
    NSInteger score = 0;
    for (NSDictionary *dict in array) {
        if ([dict[@"score"] integerValue] > score) {
            score = [dict[@"score"] integerValue];
        }
    }
    return score;
}

+ (void)addValue:(NSString *)value key :(NSString *)key{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (NSString *)getValueOfKey:(NSString *)key{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)removeValueOfKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
@end
