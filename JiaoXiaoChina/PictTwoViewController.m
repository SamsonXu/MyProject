//
//  PictTwoViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictTwoViewController.h"
#import "PictTwoCell.h"
#import "PictThreeViewController.h"
@interface PictTwoViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectView;
}
@end

@implementation PictTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    self.title = self.navTitle;
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 1;
    flow.itemSize = CGSizeMake(165, 200);
    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) collectionViewLayout:flow];
    _collectView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [self.view addSubview:_collectView];
    [_collectView registerNib:[UINib nibWithNibName:@"PictTwoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"myCell"];
}

- (void)requestData{
    NSString *path = [[NSBundle mainBundle]pathForResource:self.jsonName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _dataArray = [SignModel arrayOfModelsFromDictionaries:rootDict[@"biaozhilist"] error:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide = @"myCell";
    PictTwoCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:ide forIndexPath:indexPath];
    item.model = _dataArray[indexPath.item];
    item.itemLabel.textColor = KColorSystem;
    item.contentView.layer.masksToBounds = YES;
    item.contentView.layer.cornerRadius = 5;
    item.contentView.backgroundColor = [UIColor whiteColor];
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictThreeViewController *vc = [[PictThreeViewController alloc]init];
    vc.jsonName = self.jsonName;
    vc.currentNum = indexPath.item;
    vc.dataArr = _dataArray;
    [self.navigationController pushViewController:vc animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
