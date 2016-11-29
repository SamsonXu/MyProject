//
//  SignMolde.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface SignModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *bcount;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSDictionary<Optional> *action;
@property (nonatomic, copy) NSString <Optional>*desc;
@property (nonatomic, copy) NSString <Optional>*imageurl;
@end
