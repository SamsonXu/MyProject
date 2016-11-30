//
//  CashViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "CashViewController.h"

@interface CashViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UITextField *_field;
    UICollectionView *_collectionView;
}
@end

@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self createUI];
}

- (void)requestData{
    
    [MBProgressHUD showMessage:@"正在加载"];
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlCashList parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {
        [MBProgressHUD hideHUD];
        _dataArray = [CashModel arrayOfModelsFromDictionaries:responseObject[@"data"]];
        [_collectionView reloadData];
    } failBlock:^{
        [MBProgressHUD hideHUD];
    }];
}

- (void)createUI{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.title = @"我的现金券";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    UIView *fieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    fieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fieldView];
    
    _field = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-80, 40)];
    _field.backgroundColor = [UIColor whiteColor];
    _field.borderStyle = UITextBorderStyleNone;
    _field.placeholder = @"请输入兑换码";
    _field.font = [UIFont systemFontOfSize:14];
    
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(KScreenWidth-70, 5, 60, 30) title:@"兑换" imageName:nil];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = KColorSystem;
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fieldView addSubview:btn];
    
    _field.delegate = self;
    [fieldView addSubview:_field];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    flow.itemSize = CGSizeMake(KScreenWidth-20, 110);
    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth, KScreenHeight-104) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"CashCell" bundle:nil] forCellWithReuseIdentifier:@"myCell"];
    [self.view addSubview:_collectionView];
}

- (void)btnClick:(UIButton *)btn{
    
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlCashChange parameters:@{@"token":[DefaultManager getValueOfKey:@"token"],@"code":_field.text} sucBlock:^(id responseObject) {
        
        KMBProgressHide;
        [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
        if ([responseObject[@"status"] integerValue] == 1) {
            [self requestData];
        }
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_field resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CashCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isPay) {
        [self.delegate combackInfoWith:_dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftClick:(UIButton *)btn{
    
    if (_isPay) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [UIView animateWithDuration:1 animations:^{
            [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
