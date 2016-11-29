//
//  ClassDetailController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"
#import "ClassModel.h"
@interface ClassDetailController : RootViewController

@property (nonatomic, strong) ClassModel *model;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@end
