//
//  CommentModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/18.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface CommentModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* adopt;//是否采纳
@property (nonatomic, copy) NSString<Optional>* content;//评论内容
@property (nonatomic, copy) NSString<Optional>* create_time;//时间戳
@property (nonatomic, copy) NSString<Optional>* headimg;//头像
@property (nonatomic, copy) NSString<Optional>* pid;//评论id
@property (nonatomic, copy) NSString<Optional>* nickname;//昵称
@property (nonatomic, copy) NSString<Optional>* uid;//用户id
@property (nonatomic, copy) NSString<Optional>* wid;//话题id
@property (nonatomic, copy) NSString<Optional>* zan;//点赞数
@property (nonatomic, copy) NSArray<Optional>*replaylist;//评论回复

@end
