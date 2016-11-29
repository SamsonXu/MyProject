//
//  TestRecoderCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/12.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestRecoderModel.h"

@interface TestRecoderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic, strong) TestRecoderModel *model;

@end
