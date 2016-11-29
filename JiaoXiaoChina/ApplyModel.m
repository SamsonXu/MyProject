//
//  ApplyModel.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/14.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ApplyModel.h"

@implementation ApplyModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"pid"}];
}
@end
