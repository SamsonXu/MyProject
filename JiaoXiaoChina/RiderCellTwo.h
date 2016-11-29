//
//  RiderCellTwo.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RidersCell.h"
#import "CommentModel.h"

@protocol RidersCellTwoDelegate <NSObject>

- (void)gotoLogin;//跳转登录
- (void)changFavoriteNum:(BOOL)add pid:(NSString *)pid;//改变评论数
- (void)replyWithModel:(CommentModel *)model;

@end

@interface RiderCellTwo : RidersCell

@property (nonatomic, strong)  CommentModel *model;
@property (nonatomic, copy) NSArray *imgList;
@property (nonatomic, weak)id<RidersCellTwoDelegate>delegate;

@end
