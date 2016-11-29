//
//  QuestionBankController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "QuestionBankController.h"
#import "QuestionBankCell.h"
@interface QuestionBankController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectView;
    QuestionBankCell *_lastCell;
    NSArray *_currentArr;
}
@end

@implementation QuestionBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    self.title = @"选择考试题库";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = 1;
    flow.sectionInset = UIEdgeInsetsMake(30, 0, 0, 0);
    CGFloat width = (KScreenWidth-3)/4;
    flow.itemSize = CGSizeMake(width, width);
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) collectionViewLayout:flow];
    _collectView.dataSource = self;
    _collectView.delegate = self;
    _collectView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [_collectView registerNib:[UINib nibWithNibName:@"QuestionBankCell" bundle:nil] forCellWithReuseIdentifier:@"myCell"];
    [self.view addSubview:_collectView];
    
    UIImageView *imageView = [MyControl imageViewWithFram:CGRectMake(20, width*3+70, 15, 15) imageName:@"answer_cell_option_bg_yes"];
    [_collectView addSubview:imageView];
    
    //label
    UILabel *label = [MyControl labelWithTitle:@"已为您更新为2016年最新官方题库" fram:CGRectMake(40, width*3+70, 200, 20) color:[UIColor grayColor] fontOfSize:12 numberOfLine:1];
    [_collectView addSubview:label];
    
    //确定按钮
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0,0,0,0) title:@"确定" imageName:nil];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = KColorSystem;
    btn.layer.cornerRadius = 10;
    [_collectView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_collectView);
        make.top.mas_equalTo(width*3+110);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(KScreenWidth-40);
    }];

}

- (void)requestData{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"QuestBank" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    for (int i = 0; i < array.count; i++) {
        
        NSArray *arr = array[i];
        NSMutableArray *muArr = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < arr.count; j++) {
            NSDictionary *dict = arr[j];
            QuestinModel *model = [[QuestinModel alloc]init];
            model.imageUrl = dict[@"image"];
            model.type = dict[@"type"];
            model.driveType = dict[@"drivetype"];
            [muArr addObject:model];
        }
        [_dataArray addObject:muArr];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionBankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.section][indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_lastCell) {
        _lastCell.selectImageView.hidden = YES;
    }
    QuestionBankCell *cell = (QuestionBankCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectImageView.hidden = NO;
    _currentArr = @[[NSString stringWithFormat:@"%ld",indexPath.section],[NSString stringWithFormat:@"%ld",indexPath.row]];
    _lastCell = cell;
}

- (void)btnClick:(UIButton *)btn{
    [self showAlertViewWith:@[@"温馨提示",@"切换题库将删除之前的答题记录，是否确定切换",@"否",@"是"] sel:@selector(alertClick)];
}

- (void)alertClick{
    
    NSArray *array = @[@[@"1",@"2",@"3",@"4"],@[@"7",@"8",@"9",@"10"]];
    NSString *str1 = _currentArr[0];
    NSString *str2 = _currentArr[1];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate changeBankWithStr:array[str1.integerValue][str2.integerValue]];
    
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
