//
//  JournalModel.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/17.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JSONModel.h"

@interface JournalImageModel : NSObject

@property (nonatomic, copy) NSArray *imglist;

@end

@interface JournalModel : JSONModel
@property (nonatomic, copy) NSString<Optional>* areaid;//城市id
@property (nonatomic, copy) NSString<Optional>* cate_id;//日志id
@property (nonatomic, copy) NSString<Optional>* city;//城市名称
@property (nonatomic, copy) NSString<Optional>* create_time;//创建时间
@property (nonatomic, copy) NSString<Optional>* headimg;//头像网址
@property (nonatomic, copy) NSString<Optional>* pid;//动态id
@property (nonatomic, copy) NSString<Optional>* praise;//点赞数
@property (nonatomic, copy) NSString<Optional>* replynum;//回复数
@property (nonatomic, copy) NSString<Optional>* title;//标题
@property (nonatomic, copy) NSString<Optional>* uid;//用户id
@property (nonatomic, copy) NSString<Optional>* vice_id;//话题id
@property (nonatomic, copy) NSString<Optional>* wdnr;//内容
@property (nonatomic, copy) NSString<Optional>* wenda_cate_name;//话题类型
@property (nonatomic, copy) NSString<Optional>* is_zan;//是否点赞
@property (nonatomic, copy) NSString<Optional>* mobile_phone;//手机号
@property (nonatomic, copy) NSString<Optional>* nickname;//昵称
@property (nonatomic, copy) NSArray<Optional>* imglist;

@end
