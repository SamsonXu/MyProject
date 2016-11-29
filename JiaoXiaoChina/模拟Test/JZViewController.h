//
//  JZViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/27.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@protocol JZViewControllerDelegate <NSObject>

- (void)doPush:(UIViewController *)vc;

@end
@interface JZViewController : RootViewController
@property (nonatomic, weak)id<JZViewControllerDelegate>delegate;

@end
