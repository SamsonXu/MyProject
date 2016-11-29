//
//  PictTwoCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignModel.h"
@interface PictTwoCell : UICollectionViewCell

@property (nonatomic, strong) SignModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

@end
