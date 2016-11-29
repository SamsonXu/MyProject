//
//  JournalCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalModel.h"

@protocol JournalCellDelegate <NSObject>

- (void)changFavoriteNum:(BOOL)add pid:(NSString *)pid;

@end
@interface JournalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)favoriteBtn:(UIButton *)sender;
- (IBAction)commentBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImgView;
@property (nonatomic, strong) JournalModel *model;
@property (weak, nonatomic) IBOutlet UIView *bordView;
@property (nonatomic, weak) id<JournalCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@end
