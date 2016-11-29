//
//  TransionViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/10.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@interface TransionViewController : RootViewController
//0为错题  1为收藏
@property (nonatomic, assign) NSInteger flag;
//科目类型
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) BOOL remove;
@end
