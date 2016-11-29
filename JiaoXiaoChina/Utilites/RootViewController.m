//
//  RootViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [MyControl setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
}

- (void)createScrollView{
    
    _bootmScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49-30)];
    _bootmScrollView.contentSize = CGSizeMake(KScreenWidth, 800);
    _bootmScrollView.backgroundColor = KColorRGB(235, 235, 241);
    [self.view addSubview:_bootmScrollView];
}

- (void)requestData{
    
}

- (void)addBtnWithTitle:(UILabel *)titleLabel imageName:(NSString *)imageName navBtn:(NSString *)navBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!titleLabel) {
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }else{
        btn.frame = CGRectMake(0, 0, 35, 35);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(btn).insets(UIEdgeInsetsMake(10, 0, 0, 0));
        }];
    }
    [self.view addSubview:btn];
    
    if ([navBtn isEqualToString:KNavBarLeft]) {
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        item1.width = -10;
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItems = @[item1,item2];
        [btn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([navBtn isEqualToString:KNavBarRight]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)leftClick:(UIButton *)btn{
    
}

- (void)rightClick:(UIButton *)btn{
    
}

- (void)addRefreshHasHeader:(BOOL)header hasFooter:(BOOL)footer{
    if (header) {
        _tableView.header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [_tableView.header beginRefreshing];
    }
    if (footer) {
        _tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
}

- (void)refresh{
    
}

- (void)loadMore{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)showAlertViewWith:(NSArray *)titles sel:(SEL)sel{
    UIAlertAction *action1;
    if (titles.count == 2) {
        _alertCtrl = [UIAlertController alertControllerWithTitle:titles[0] message:nil preferredStyle:UIAlertControllerStyleAlert];
        action1 = [UIAlertAction actionWithTitle:titles[1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertCtrl addAction:action1];
        [self presentViewController:_alertCtrl animated:YES completion:nil];
    }else{
        _alertCtrl = [UIAlertController alertControllerWithTitle:titles[0] message:titles[1] preferredStyle:UIAlertControllerStyleAlert];
        [_alertCtrl addAction:[UIAlertAction actionWithTitle:titles[2] style:UIAlertActionStyleCancel handler:nil]];
        action1 = [UIAlertAction actionWithTitle:titles[3] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
        }];
        [_alertCtrl addAction:action1];
        [self presentViewController:_alertCtrl animated:YES completion:nil];
        
    }
    
}

@end
