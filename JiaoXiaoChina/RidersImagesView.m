//
//  RidersImagesView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RidersImagesView.h"

@implementation RidersImagesView
{
    NSMutableArray *_imageViews;
    CGSize _imgSize;
}

-(instancetype)init{
    if (self = [super init]) {
        _imageViews = [NSMutableArray new];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [_imageViews addObject:imageView];
    }
}

- (void)setImages:(NSArray *)images{
    _images = images;
    [self changeConstraint];
}

- (void)changeConstraint{
    for (int i = 0; i < _imageViews.count; i++) {
        UIImageView *imageView = _imageViews[i];
        if (i < _images.count) {
            imageView.hidden = NO;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_images[i][@"imgpath"]]]];
            
            UIImage *scaleImg = [MyControl thumbnailWithImageWithoutScale:image size:CGSizeMake(80, 80)];
            imageView.image = scaleImg;
        }else{
            imageView.hidden = YES;
            imageView.image = nil;
        }
    }
    if (_images.count == 4) {
        [self sudukuWithLineCount:2];
    }else{
        [self sudukuWithLineCount:3];
    }
}

- (void)sudukuWithLineCount:(NSInteger)lineNum{
    KWS(ws);
    UIView *lastView = nil;
    for (int i = 0; i < _images.count; i++) {
        UIImageView *imageView = _imageViews[i];
        imageView.tag = 100+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        [imageView addGestureRecognizer:tap];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                //第一个视图的top和left的约束
                make.top.left.equalTo(ws);
            }else if (i%lineNum == 0){
                //第一列非第一个视图top和left的约束
                make.top.equalTo(lastView.mas_bottom).offset(5);
                make.left.equalTo(ws);
            }else{
                //其他视图的约束
                make.top.equalTo(lastView);
                make.left.equalTo(lastView.mas_right).offset(5);
                make.width.equalTo(lastView);
            }
            make.height.width.mas_equalTo(100);
        }];
        lastView = imageView;
    }
    NSInteger row = (_images.count-1)/lineNum+1;
    [ws mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(row*100+(row-1)*5);
    }];
}

- (void)showBigImage:(UITapGestureRecognizer *)tap{

    NSInteger index = tap.view.tag-100;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_images[index][@"imgpath"]]]];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    UITapGestureRecognizer *bigTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBigImage:)];
    [imageView addGestureRecognizer:bigTap];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    [keyWindow addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(keyWindow);
        make.size.mas_equalTo(CGSizeMake(image.size.width, image.size.height));
    }];
}

- (void)hideBigImage:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:1 animations:^{
        tap.view.alpha = 0;
    }];
}
@end
