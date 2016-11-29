//
//  QuestionBankCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestinModel.h"
@interface QuestionBankCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *driveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (nonatomic, strong) QuestinModel *model;

@end
