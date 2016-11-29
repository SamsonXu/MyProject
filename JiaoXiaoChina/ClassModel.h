//
//  ClassModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/14.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface ClassModel : JSONModel

@property (nonatomic, copy) NSString <Optional>* pid;//班型ID
@property (nonatomic, copy) NSString <Optional>* title;//班型名称
@property (nonatomic, copy) NSString <Optional>* chex;//车型id
@property (nonatomic, copy) NSString <Optional>* chex_arr;//车型
@property (nonatomic, copy) NSString <Optional>* cheben_arr;//车本
@property (nonatomic, copy) NSString <Optional>* pic_type;//图片类型
@property (nonatomic, copy) NSString <Optional>* kcimg;//课程图片
@property (nonatomic, copy) NSString <Optional>* jiage;//正常价格
@property (nonatomic, copy) NSString <Optional>* pric;//优惠价
@property (nonatomic, copy) NSString <Optional>* is_tui;//是否为推荐
@property (nonatomic, copy) NSString <Optional>* xl_time;//训练时间
@property (nonatomic, copy) NSString <Optional>* onead;//广告语
@property (nonatomic, copy) NSString <Optional>* labelids;//标签id
@property (nonatomic, copy) NSString <Optional>* is_payment_type;//支付类型:0不支持支付,1按优惠价支付,2首付
@property (nonatomic, copy) NSString <Optional>* is_payment;//是否开通支付:0不支持支付，1支持支付
@property (nonatomic, copy) NSString <Optional>* yufujin;//预付金
@property (nonatomic, copy) NSString <Optional>* dipric;//抵扣金
@property (nonatomic, copy) NSString <Optional>* label_str;//标签文字
@property (nonatomic, copy) NSString <Optional>* dbimg;//图片
@property (nonatomic, copy) NSString <Optional>* label_kecheng;//课程标签
@property (nonatomic, copy) NSString <Optional>* dname;//驾校名称
@property (nonatomic, copy) NSString <Optional>* did;//驾校id
@property (nonatomic, copy) NSString <Optional>* tel;//驾校电话
@property (nonatomic, copy) NSString <Optional>* Distance;//距离
@end
