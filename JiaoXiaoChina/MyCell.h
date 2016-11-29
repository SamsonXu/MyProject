//
//  MyCell.h
//  MyFamily
//
//  Created by qianfeng on 16/3/18.
//  Copyright (c) 2016年 Motion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface MyCellModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, copy) NSString<Optional> *leftTitle;
@property (nonatomic, copy) NSString<Optional> *rightTitle;
@end

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *myCellLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCellDetailLabel;
@property (nonatomic, strong) MyCellModel *model;

@end
