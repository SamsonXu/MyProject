//
//  StarView1.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "StarView.h"

@implementation StarView

{
    UIImageView *_bgImageView;
    UIImageView *_frontImageView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView];
    }
    return self;
}

//在cell上使用自己封装的View，我们重写-(id)initWithCoder:(NSCoder *)aDecoder
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self customView];
    }
    return self;
}

-(void)customView{
    _bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    _bgImageView.contentMode = UIViewContentModeLeft;
    _bgImageView.clipsToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"star1@3x0"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _bgImageView.image=image;
    [self addSubview:_bgImageView];
    
    _frontImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    _frontImageView.contentMode = UIViewContentModeLeft;
    _frontImageView.image = [UIImage imageNamed:@"star1@3x5"];
    _frontImageView.clipsToBounds = YES;
    [self addSubview:_frontImageView];
}

-(void)setStarNum:(CGFloat)num{
    _frontImageView.frame=CGRectMake(0, 0, num/5.0*120, 20);
}

@end
