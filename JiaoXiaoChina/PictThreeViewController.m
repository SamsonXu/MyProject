//
//  PictThreeViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictThreeViewController.h"
#import "PictThreeCell.h"
@interface PictThreeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectView;
}
@end

@implementation PictThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentNum+1,_dataArr.count];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(KScreenWidth, KScreenHeight-64);
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) collectionViewLayout:flow];
    _collectView.pagingEnabled = YES;
    _collectView.showsVerticalScrollIndicator = YES;
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.contentOffset = CGPointMake(self.currentNum*KScreenWidth, 0);
    [self.view addSubview:_collectView];
    [_collectView registerNib:[UINib nibWithNibName:@"PictThreeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"myCell"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide = @"myCell";
    PictThreeCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:ide forIndexPath:indexPath];
    item.model = _dataArr[indexPath.item];
    item.contentView.backgroundColor = [UIColor whiteColor];
    return item;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentNum = scrollView.contentOffset.x/KScreenWidth;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentNum+1,_dataArr.count];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
