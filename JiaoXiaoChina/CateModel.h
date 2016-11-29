//
//  CateModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface CateModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *adstr;//说明
@property (nonatomic, copy) NSString<Optional> *pid;//类型id
@property (nonatomic, copy) NSString<Optional> *imgpath;//类型图片
@property (nonatomic, copy) NSString<Optional> *name;//类型名称
@end
