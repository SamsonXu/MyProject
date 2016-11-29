//
//  ListModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/1.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface ListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *title_img;
@property (nonatomic, copy) NSString<Optional> *update_time;
@property (nonatomic, copy) NSString<Optional> *click_count;

@end
