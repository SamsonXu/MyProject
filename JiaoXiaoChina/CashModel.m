//
//  CashModel.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "CashModel.h"

@implementation CashModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"pid",@"typeid":@"ptypeid"}];
}
@end
