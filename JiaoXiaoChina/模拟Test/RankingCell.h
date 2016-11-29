//
//  RankingCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
@interface RankingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (nonatomic ,strong) RankModel *model;

@end
