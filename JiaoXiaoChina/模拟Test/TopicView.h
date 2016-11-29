//
//  TopicView.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicViewDelegate <NSObject>
//改变显示的题目数
- (void)changePage:(NSInteger)index;
//改变已答、未答题数
- (void)changeNumOfItem:(BOOL)isTrue;
//改变抽屉视图按钮颜色
- (void)changeColorWithNum:(NSInteger)num right:(BOOL)right;
//多选提示
- (void)showMulViewWith:(NSArray *)array;

@end

@interface TopicView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{@public
    UICollectionView *_collectView;
    

}

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic,assign) NSInteger font;
@property (nonatomic,assign) BOOL showAns;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic, weak) id <TopicViewDelegate>delegate;
@property (nonatomic, weak) id<TopicViewDelegate>delegate1;
@property (nonatomic, assign) BOOL remove;
- (void)changeFontWithNum:(NSInteger)num;

- (void)showAns:(BOOL)show;

@end
