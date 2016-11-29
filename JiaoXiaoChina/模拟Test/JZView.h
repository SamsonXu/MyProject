//
//  JZView.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/27.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZViewDelegate <NSObject>

- (void)pushWithTag:(NSInteger)tag flag:(NSInteger)flag;

@end
@interface JZView : UIView

@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, weak) id<JZViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName titles:(NSArray *)titles;

@end
