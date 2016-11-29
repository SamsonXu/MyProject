//
//  RidersCell.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalModel.h"
#import "RidersImagesView.h"
#import "RidersCommentView.h"

@interface RidersCell : UITableViewCell
{
    UIView *_lastView;
    UIView *_bgView;
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    UILabel *_typeLabel;
    UILabel *_timeLabel;
    UIButton *_favoBtn;
    UILabel *_favoLabel;
    UIImageView *_favoView;
    UIButton *_comBtn;
    UILabel *_comLabel;
    UIImageView *_comView;
    UILabel *_cityLabel;
    UILabel *_topicLabel;
    RidersImagesView *_ridersImgsView;
    RidersCommentView *_ridComtView;
    MASConstraint *_bottomContent;
    MASConstraint *_bottomTopic;
    MASConstraint *_bottomImage;
    MASConstraint *_bottomType;
    MASConstraint *_bottomComment;
}

//@property (nonatomic, strong) JournalModel *model;
//@property (nonatomic, copy) NSArray *imgList;
//@property (nonatomic, weak)id<RidersCellDelegate>delegate;


- (void)createUI;
@end
