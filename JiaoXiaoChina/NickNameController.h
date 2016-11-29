//
//  NickNameController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/18.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@protocol NickNameDelegate <NSObject>

- (void)changeNameWithName:(NSString *)name;

@end
@interface NickNameController : RootViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id<NickNameDelegate>delegate;

@end
