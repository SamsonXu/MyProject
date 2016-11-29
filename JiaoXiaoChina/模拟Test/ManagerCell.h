//
//  ManagerCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@protocol ManagerCellDelegate <NSObject>

- (void)download;

@end

@interface ManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ramLabel;

@property (weak, nonatomic) IBOutlet UILabel *downLoadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downLoadImage;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *downLoadProgress;

@property (nonatomic, strong) MovieModel *model;
@property (nonatomic, weak) id<ManagerCellDelegate> delegate;

@end
