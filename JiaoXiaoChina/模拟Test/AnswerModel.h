//
//  AnswerModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/29.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject

@property (nonatomic, assign) int pid;//题目序号（id）
@property (nonatomic, assign) int dui;//答对总记录
@property (nonatomic, assign) int cuo;//答错总记录
@property (nonatomic, assign) int lx;//试题类型：选择/判断
@property (nonatomic, assign) int tid;//题库类别
@property (nonatomic, assign) int fid;//题库分类
@property (nonatomic, assign) int cid;//驾照类型
@property (nonatomic, copy) NSString *title;//试题标题
@property (nonatomic, copy) NSString *pic;//图片地址
@property (nonatomic, assign) int select_type;//选择题类型
@property (nonatomic, copy) NSString *answer;//正确答案
@property (nonatomic, assign) int status;//试题状态
@property (nonatomic, assign) int nandu;//难易程度
@property (nonatomic, copy) NSString *acode;//城市字符串
@property (nonatomic, copy) NSString *xid;//题型ID
@property (nonatomic, assign) int topnum;//点赞记录数
@property (nonatomic, copy) NSString *jiehsi;//试题解析
@property (nonatomic, copy) NSString *detail;//选择题选项
@property (nonatomic, copy) NSString *shipingmp;//视频地址
@end
