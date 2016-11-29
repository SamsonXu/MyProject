//
//  DriveCommentCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "DrivCommentModel.h"
@interface DriveCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet StarView *starView;

@property (nonatomic, strong) DrivCommentModel *model;
@end
