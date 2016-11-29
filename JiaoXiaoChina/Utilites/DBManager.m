//
//  MyDataManager.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/28.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
{
    //数据库管理对象
    FMDatabase *_fmdb;
}

+ (DBManager *)shareManager{
    static DBManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager) {
            manager = [[DBManager alloc]init];
        }
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"subject" ofType:@".sqlite"];
        _fmdb = [[FMDatabase alloc]initWithPath:path];
    }
    if ([_fmdb open]) {
        NSLog(@"open success");
    }else{
        NSLog(@"%@",_fmdb.lastError);
    }
    return self;
}

- (NSMutableArray *)selectDataWithDataType:(DataType)type Flag:(NSInteger)flag{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *sqlString = [[NSString alloc]init];
    switch (type) {
        case chapter:
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSInteger jzNumber = [defaults integerForKey:KJZLX];
            sqlString = [NSString stringWithFormat:@"select * from zjx_exam_fl where tid=%ld and cid in ('0','%ld')",flag,jzNumber];
            FMResultSet *set = [_fmdb executeQuery:sqlString];
            while ([set next]) {
                AnswerModel *model = [AnswerModel new];
                model.title = [set stringForColumn:@"title"];
                model.cid = [set intForColumn:@"cid"];
                model.fid = [set intForColumn:@"id"];
                [array addObject:model];
            }
        }
            break;
            case itemTp:
        {
            sqlString = @"select * from zjx_exam_tx";
            FMResultSet *set = [_fmdb executeQuery:sqlString];
            while ([set next]) {
                DataModel *model = [DataModel new];
                model.title = [set stringForColumn:@"txname"];
                [array addObject:model];
            }
        }
            break;
            case answer:
        {
            if (flag == 4) {
                sqlString = [NSString stringWithFormat:@"select * from zjx_exam where cid=%ld",flag];
            }else{
                sqlString = [NSString stringWithFormat:@"select * from zjx_exam where cid in ('0','%ld')",flag];
            }
            
            FMResultSet *set = [_fmdb executeQuery:sqlString];
            while ([set next]) {
                AnswerModel *model = [[AnswerModel alloc]init];
                 model.pid = [set intForColumn:@"id"];
                model.dui = [set intForColumn:@"dui"];
                model.cuo = [set intForColumn:@"cuo"];
                model.lx = [set intForColumn:@"lx"];
                model.tid = [set intForColumn:@"tid"];
                model.fid = [set intForColumn:@"fid"];
                model.cid = [set intForColumn:@"cid"];
                model.select_type = [set intForColumn:@"select_type"];
                model.status = [set intForColumn:@"status"];
                model.nandu = [set intForColumn:@"nandu"];
                model.topnum = [set intForColumn:@"topnum"];
                model.title = [set stringForColumn:@"title"];
                model.pic = [set stringForColumn:@"pic"];
                model.answer = [set stringForColumn:@"answer"];
                model.acode = [set stringForColumn:@"acode"];
                model.xid = [set stringForColumn:@"xid"];
                model.jiehsi = [set stringForColumn:@"jieshi"];
                model.detail = [set stringForColumn:@"detail"];
                model.shipingmp = [set stringForColumn:@"shipingmp"];
                [array addObject:model];
            }
        }
            break;
        case chapAns:
        {
            
            FMResultSet *set = [_fmdb executeQuery:sqlString];
            while ([set next]) {
                AnswerModel *model = [[AnswerModel alloc]init];
                model.pid = [set intForColumn:@"id"];
                model.dui = [set intForColumn:@"dui"];
                model.cuo = [set intForColumn:@"cuo"];
                model.lx = [set intForColumn:@"lx"];
                model.tid = [set intForColumn:@"tid"];
                model.fid = [set intForColumn:@"fid"];
                model.cid = [set intForColumn:@"cid"];
                model.select_type = [set intForColumn:@"select_type"];
                model.status = [set intForColumn:@"status"];
                model.nandu = [set intForColumn:@"nandu"];
                model.topnum = [set intForColumn:@"topnum"];
                model.title = [set stringForColumn:@"title"];
                model.pic = [set stringForColumn:@"pic"];
                model.answer = [set stringForColumn:@"answer"];
                model.acode = [set stringForColumn:@"acode"];
                model.xid = [set stringForColumn:@"xid"];
                model.jiehsi = [set stringForColumn:@"jieshi"];
                model.detail = [set stringForColumn:@"detail"];
                model.shipingmp = [set stringForColumn:@"shipingmp"];
                [array addObject:model];
            }
        }
        default:
            break;
    }
    return array;
}

- (NSMutableArray *)chapTitleWithfl:(NSInteger)fid{
    NSString *sqlString = [NSString stringWithFormat:@"select * from zjx_exam_fl where id=%ld",fid];
    FMResultSet *set = [_fmdb executeQuery:sqlString];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([set next]) {
        AnswerModel *model = [AnswerModel new];
        model.title = [set stringForColumn:@"title"];
        model.cid = [set intForColumn:@"cid"];
        model.fid = [set intForColumn:@"id"];
        [array addObject:model];
    }
    return array;
}

- (NSMutableArray *)selectDataWithCb:(NSInteger)cb{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *sqlString = [[NSString alloc]init];
    NSArray *changeArr = @[@"5",@"4",@"6",@"3"];
    if (cb < 4) {
        sqlString = [NSString stringWithFormat:@"select * from zjx_exam where cid in ('0','%ld') and status=1",cb];
    }else if (cb == 4){
        sqlString = [NSString stringWithFormat:@"select * from zjx_exam where cid=4 and status=1"];
    }else if (cb > 4){
        sqlString = [NSString stringWithFormat:@"select * from zjx_exam where tid=%ld and status=1",[changeArr[cb-7] integerValue]];
    }
    
    FMResultSet *set = [_fmdb executeQuery:sqlString];
    while ([set next]) {
        AnswerModel *model = [[AnswerModel alloc]init];
        model.pid = [set intForColumn:@"id"];
        model.dui = [set intForColumn:@"dui"];
        model.cuo = [set intForColumn:@"cuo"];
        model.lx = [set intForColumn:@"lx"];
        model.tid = [set intForColumn:@"tid"];
        model.fid = [set intForColumn:@"fid"];
        model.cid = [set intForColumn:@"cid"];
        model.select_type = [set intForColumn:@"select_type"];
        model.status = [set intForColumn:@"status"];
        model.nandu = [set intForColumn:@"nandu"];
        model.topnum = [set intForColumn:@"topnum"];
        model.title = [set stringForColumn:@"title"];
        model.pic = [set stringForColumn:@"pic"];
        model.answer = [set stringForColumn:@"answer"];
        model.acode = [set stringForColumn:@"acode"];
        model.xid = [set stringForColumn:@"xid"];
        model.jiehsi = [set stringForColumn:@"jieshi"];
        model.detail = [set stringForColumn:@"detail"];
        model.shipingmp = [set stringForColumn:@"shipingmp"];
        [array addObject:model];
    }
    return array;
}

- (NSMutableArray *)selectDataWithTk:(NSInteger)tk arr:(NSArray *)currentArr{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (AnswerModel *model in currentArr) {
        if (model.tid == tk) {
            [array addObject:model];
        }
    }
    return array;
}

- (BOOL)hasFileWithPath:(NSString *)path{
    NSString *documentStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentStr stringByAppendingPathComponent:path];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }else{
        return NO;
    }
}

@end
