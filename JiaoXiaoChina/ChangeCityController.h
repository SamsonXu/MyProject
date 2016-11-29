//
//  ChangeCityController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@protocol ChangeCityDelegate <NSObject>

- (void)changeCityName:(NSString *)name;
- (void)changeCityInfo:(NSArray *)info;
@end
@interface ChangeCityController : RootViewController
@property (nonatomic, weak) id<ChangeCityDelegate>delegate;
@property (nonatomic, weak) id<ChangeCityDelegate>infoDelegate;
@property (nonatomic, assign) BOOL isInfo;

@end
