//
//  RidersViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"
#import "RiderCellOne.h"
@interface RidersViewController : RootViewController<RidersCellOneDelegate>
{
    //当前页数
    NSInteger _urlPage;
    //总页数
    NSInteger _totlePage;
    NSString *_userNum;
    NSString *_topicNum;
}

@end
