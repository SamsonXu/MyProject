//
//  ListCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/1.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *listImageView;
@property (weak, nonatomic) IBOutlet UILabel *listReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listTimeLabel;
@property (nonatomic, strong) ListModel *model;

@end
