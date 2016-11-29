//
//  CashModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface CashModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *code;//红包码
@property (nonatomic, copy) NSString<Optional> *end_time;//结束时间
@property (nonatomic, copy) NSString<Optional> *endday;//有效期
@property (nonatomic, copy) NSString<Optional> *pid;//红包id
@property (nonatomic, copy) NSString<Optional> *is_use;//是否使用
@property (nonatomic, copy) NSString<Optional> *price;//红包金额
@property (nonatomic, copy) NSString<Optional> *start_time;//领取时间
@property (nonatomic, copy) NSString<Optional> *title;//红包名称
@property (nonatomic, copy) NSString<Optional> *ptypeid;//类型
@property (nonatomic, copy) NSString<Optional> *userid;//用户id
@property (nonatomic, copy) NSString<Optional> *str_end_time;//结束时间
@property (nonatomic, copy) NSString<Optional> *str_area;//使用范围
@property (nonatomic, copy) NSString<Optional> *is_expire;//
@end
