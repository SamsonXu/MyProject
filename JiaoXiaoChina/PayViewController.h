//
//  PayViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"
#import "ClassModel.h"
@interface PayViewController : RootViewController

@property (nonatomic, assign) BOOL isOrder;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) ClassModel *model;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *userName;
@end
