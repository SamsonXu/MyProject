//
//  SheetView.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/6.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SheetViewDelegate <NSObject>

- (void)sheetViewClick:(NSInteger)index;

- (void)changeBtnNum:(NSInteger)index;

@end
@interface SheetView : UIView
{
    @public
    UIView *_backView;
}
@property (nonatomic, weak)id <SheetViewDelegate> delegate;
@property (nonatomic, assign) NSInteger trueNum;
@property (nonatomic, assign) NSInteger faultNum;
@property (nonatomic, assign) BOOL isTest;
-(instancetype)initWithFrame:(CGRect)frame view:(UIView *)superView number:(int)num;
//改变对错记录
- (void)changeNumberWithNum:(NSArray *)array;
//改变按钮颜色
- (void)changeColorWithNum:(NSInteger)num right:(BOOL)right;
@end
