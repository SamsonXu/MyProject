//
//  ApplyCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyModel.h"
#import "StarView.h"
@interface ApplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) ApplyModel *model;

@end
