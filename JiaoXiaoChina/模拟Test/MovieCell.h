//
//  MovieCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
@interface MovieCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;

@property (nonatomic, strong) MovieModel *model;


@end
