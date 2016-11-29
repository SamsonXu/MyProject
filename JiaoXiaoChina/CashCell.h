//
//  CashCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashModel.h"
@interface CashCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) CashModel *model;

@end
