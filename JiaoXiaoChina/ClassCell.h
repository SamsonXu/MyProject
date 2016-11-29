//
//  ClassCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
@interface ClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yufuLabel;
@property (weak, nonatomic) IBOutlet UILabel *sign1Label;
@property (weak, nonatomic) IBOutlet UILabel *sign2Label;
@property (weak, nonatomic) IBOutlet UILabel *oneadLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yufuImageView;
@property (weak, nonatomic) IBOutlet UILabel *driveLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;


@property (nonatomic, strong) ClassModel *model;

@end
