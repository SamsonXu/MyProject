//
//  OrderCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/21.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@protocol OrderCellDelegate <NSObject>

- (void)pushToPayViewCtrl:(OrderModel *)orderModel;

@end

@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *driveLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *chebenLabel;
- (IBAction)payBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, weak) id<OrderCellDelegate>delegate;

@end
