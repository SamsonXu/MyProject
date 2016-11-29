//
//  RankModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface RankModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *aid;//城市id
@property (nonatomic, copy) NSString<Optional> *cnum;//错误题数
@property (nonatomic, copy) NSString<Optional> *create_time;//答题时间
@property (nonatomic, copy) NSString<Optional> *dnum;//答对题数
@property (nonatomic, copy) NSString<Optional> *fenshu;//分数
@property (nonatomic, copy) NSString<Optional> *headimg;//头像
@property (nonatomic, copy) NSString<Optional> *pid;//信息id
@property (nonatomic, copy) NSString<Optional> *kid;//科目id
@property (nonatomic, copy) NSString<Optional> *kstime;//考试时间
@property (nonatomic, copy) NSString<Optional> *nickname;//昵称
@property (nonatomic, copy) NSString<Optional> *sex;//性别
@property (nonatomic, copy) NSString<Optional> *uid;//用户id
@end
