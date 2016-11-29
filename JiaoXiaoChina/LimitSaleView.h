//
//  LimitSale.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@protocol LimitSaleViewDelegate <NSObject>

- (void)doPushWithTime:(CGFloat)time;

@end
@interface LimitSaleView : UIView
{
    NSTimeInterval _inte;
    NSTimer *_timer;
}
@property (nonatomic, strong) ClassModel *model;
@property (nonatomic, weak) id<LimitSaleViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame model:(ClassModel *)model time:(NSString *)time;
@end
