//
//  RidersCommentView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/24.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RidersCommentView.h"

@implementation RidersCommentView
{
    UIView *_bgView;
}

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    KWS(ws);
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)setCommentArray:(NSArray *)commentArray{
    _commentArray = commentArray;
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
    UIView *lastView = nil;
    for (int i = 0; i < commentArray.count; i++) {
        UILabel *label = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14 numberOfLine:0];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *dict = commentArray[i];
        label.text = [NSString stringWithFormat:@"%@:%@",dict[@"nickname"],dict[@"contnr"]];
        [_bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.equalTo(_bgView).offset(10);
            }
            make.left.equalTo(_bgView).offset(5);
            make.right.equalTo(_bgView).offset(-5);
        }];
        lastView = label;
    }
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView).offset(5);
    }];
}
@end
