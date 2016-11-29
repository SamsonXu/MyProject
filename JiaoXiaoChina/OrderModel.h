//
//  OrderModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/30.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface OrderModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *areaid;//城市id
@property (nonatomic, copy) NSString<Optional> *cityname;//城市名称
@property (nonatomic, copy) NSString<Optional> *cheben_arr;//
@property (nonatomic, copy) NSString<Optional> *chex_arr;//
@property (nonatomic, copy) NSString<Optional> *count_price;//
@property (nonatomic, copy) NSString<Optional> *create_time;//
@property (nonatomic, copy) NSString<Optional> *did;//
@property (nonatomic, copy) NSString<Optional> *dipric;//
@property (nonatomic, copy) NSString<Optional> *dname;//
@property (nonatomic, copy) NSString<Optional> *pid;//订单id
@property (nonatomic, copy) NSString<Optional> *is_expire;//
@property (nonatomic, copy) NSString<Optional> *is_partner;//
@property (nonatomic, copy) NSString<Optional> *is_payment;//
@property (nonatomic, copy) NSString<Optional> *is_payment_type;//
@property (nonatomic, copy) NSString<Optional> *kcid;//
@property (nonatomic, copy) NSString<Optional> *o_sn;//
@property (nonatomic, copy) NSString<Optional> *onead;//
@property (nonatomic, copy) NSString<Optional> *payment_type;//
@property (nonatomic, copy) NSString<Optional> *redprice;//
@property (nonatomic, copy) NSString<Optional> *rid;//
@property (nonatomic, copy) NSString<Optional> *tel;//
@property (nonatomic, copy) NSString<Optional> *title;//
@property (nonatomic, copy) NSString<Optional> *userid;//
@property (nonatomic, copy) NSString<Optional> *username;//
@property (nonatomic, copy) NSString<Optional> *yufujin;//
@end
