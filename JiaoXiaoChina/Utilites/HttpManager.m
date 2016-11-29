//
//  HttpManager.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+ (HttpManager *)shareManager{
    static HttpManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager) {
            manager = [[HttpManager alloc]init];
        }
    });
    return manager;
}

- (void)requestDataWithMethod:(NSString *)method urlString:(NSString *)urlString parameters:(id)parameters sucBlock:(sucBlock)sucBlock failBlock:(failBlock)failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
   
    if ([method isEqualToString:KUrlGet]) {
        [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sucBlock) {
                sucBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if ([method isEqualToString:KUrlPost]){
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sucBlock) {
                sucBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if ([method isEqualToString:KUrlPut]){
        [manager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sucBlock) {
                sucBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}

@end
