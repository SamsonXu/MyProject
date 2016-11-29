//
//  CashViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"
#import "CashCell.h"
@protocol CashViewCtrlDelegate <NSObject>

- (void)combackInfoWith:(CashModel *)model;

@end

@interface CashViewController : RootViewController

@property (nonatomic, assign) BOOL isPay;
@property (nonatomic, weak)id<CashViewCtrlDelegate>delegate;

@end
