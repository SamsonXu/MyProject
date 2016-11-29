//
//  HttpManager.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^sucBlock)(id responseObject);
typedef void(^failBlock)();

@interface HttpManager : NSObject

+ (HttpManager *)shareManager;

//网络请求
- (void)requestDataWithMethod:(NSString *)method urlString:(NSString *)urlString parameters:(id)parameters sucBlock:(sucBlock)sucBlock failBlock:(failBlock)failBlock;
//下载数据
- (void)downLoadDataWithUrl:(NSString *)url progress:(NSProgress *)progress urlName:(NSString *)urlName;

@property (nonatomic, weak) sucBlock sucBlock;
@property (nonatomic, weak) failBlock failBlock;

@end
