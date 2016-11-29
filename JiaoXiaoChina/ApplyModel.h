//
//  ApplyModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/14.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface ApplyModel : JSONModel

@property (nonatomic, copy) NSString <Optional>* pid;//驾校ID
@property (nonatomic, copy) NSString <Optional>* dname;//驾校名称
@property (nonatomic, copy) NSString <Optional>* dbimg;//数据图片
@property (nonatomic, copy) NSString <Optional>* logo;//logo图片
@property (nonatomic, copy) NSString <Optional>* usergroup;//会员等级、1普通
@property (nonatomic, copy) NSString <Optional>* score;//驾校评分
@property (nonatomic, copy) NSString <Optional>* clicknum;//查看次数
@property (nonatomic, copy) NSString <Optional>* address;//详细地址
@property (nonatomic, copy) NSString <Optional>* minprice;//最低价格
@property (nonatomic, copy) NSString <Optional>* is_partner;//是否为合作伙伴
@property (nonatomic, copy) NSString <Optional>* kecheng_id;//最低价格课程ID
@property (nonatomic, copy) NSString <Optional>* kcids;//所有课程ID
@property (nonatomic, copy) NSString <Optional>* Distance;//距离
@property (nonatomic, copy) NSString <Optional>* is_payment;//是否开通支付，1开通，0未开通
@property (nonatomic, copy) NSString <Optional>* county;//区
@property (nonatomic, copy) NSString <Optional>* city;//市
@property (nonatomic, copy) NSString <Optional>* order_num;//报名人数
@property (nonatomic, copy) NSString <Optional>* plnum;//评论人数
@property (nonatomic, copy) NSString <Optional>* tel;//驾校电话
@end
