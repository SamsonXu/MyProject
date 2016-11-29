//
//  RiderCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CateModel.h"
@interface TopicCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topicImgView;

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

@property (nonatomic, strong) CateModel *model;

@end
