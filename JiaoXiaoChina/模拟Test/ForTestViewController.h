//
//  ForTestViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"
#import "RidersTopicController.h"
#import "CateModel.h"
@protocol ForTestVCProtocal <NSObject>

- (void)doPushWithVc:(UIViewController *)vc;

@end
@interface ForTestViewController : RootViewController

@property (nonatomic, weak)id<ForTestVCProtocal>delegate;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger height;
- (void)addHeadViewWithFlag;
- (void)addImageViewWithImageUrl:(NSString *)imageUrl;
- (void)headBtnClick:(UIButton *)btn;
- (void)selfTestClick:(UIButton *)btn;

@end
