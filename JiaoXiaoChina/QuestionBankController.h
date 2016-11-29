//
//  QuestionBankController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@protocol QuestionBankDelegate <NSObject>

- (void)changeBankWithStr:(NSString *)drive;

@end
@interface QuestionBankController : RootViewController

@property (nonatomic ,weak) id<QuestionBankDelegate>delegate;

@end
