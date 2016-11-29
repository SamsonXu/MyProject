//
//  DetailCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/17.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalModel.h"
@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locatLabel;

@property (nonatomic, strong) JournalModel *model;

@end
