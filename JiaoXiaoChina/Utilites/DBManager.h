//
//  MyDataManager.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/28.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "AnswerModel.h"
typedef enum {
    chapter,//章节练习
    itemTp,//题型
    answer,//题目
    chapAns,//章节题目
}DataType;
@interface DBManager : NSObject
//单例
+(DBManager *)shareManager;
//插入
-(void)insertModel:(DataModel *)model;
//筛选数据
-(NSMutableArray *)selectDataWithDataType:(DataType)type Flag:(NSInteger)flag;
//更新数据
-(void)updateModel:(DataModel *)model withId:(NSInteger)beautyId;
//路径下是否有文件
- (BOOL)hasFileWithPath:(NSString *)path;
//当前章节类型的题目
- (NSMutableArray *)chapTitleWithfl:(NSInteger)fid;

//当前驾照类型下题目
- (NSMutableArray *)selectDataWithCb:(NSInteger)cb;
//当前科目类型下题目
- (NSMutableArray *)selectDataWithTk:(NSInteger)tk arr:(NSArray *)currentArr;
//将数组归档
- (void)writeArrayToFileWith:(NSArray *)array type:(NSString *)type;
@end
