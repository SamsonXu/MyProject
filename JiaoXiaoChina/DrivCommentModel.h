//
//  DrivCommentModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface DrivCommentModel : JSONModel

@property (nonatomic, copy) NSString <Optional>* avgnum;//评论分数
@property (nonatomic, copy) NSString <Optional>* create_time;//评论时间
@property (nonatomic, copy) NSString <Optional>* did;//驾校ID
@property (nonatomic, copy) NSString <Optional>* headimg;//头像
@property (nonatomic, copy) NSString <Optional>* pid;//评论id
@property (nonatomic, copy) NSString <Optional>* is_face;//
@property (nonatomic, copy) NSString <Optional>* mobile_phone;//手机号
@property (nonatomic, copy) NSString <Optional>* nickname;//昵称
@property (nonatomic, copy) NSString <Optional>* plnr;//评论内容
@property (nonatomic, copy) NSString <Optional>* sex;//性别
@end
