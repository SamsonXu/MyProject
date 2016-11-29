//
//  TestView.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestViewDelegate <NSObject>
- (void)testViewWithtag:(NSInteger)tag flag:(NSInteger)flag;

@end
@interface TestView : UIView
{
    NSInteger _flag;
}
@property (nonatomic, weak)id<TestViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame flag:(NSInteger)flag;

@end
