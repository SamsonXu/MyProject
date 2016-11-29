//
//  TestViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TestViewController.h"
#import "TwoThreeViewController.h"
#import "OneFourViewController.h"
#import "JZViewController.h"
#import "LoginViewController.h"
#import "FeedBackViewController.h"
@interface TestViewController ()<UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,ForTestVCProtocal,JZViewControllerDelegate>
{
    UIScrollView *_scrollView;
    NSArray *_btnName;
    UILabel *_bottmLabel;
    NSMutableArray *_viewCtrls;
    UIPageViewController *_pageViewCtrl;
}

@end

@implementation TestViewController

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[DefaultManager getValueOfKey:KJZLX] integerValue] > 4) {
        [self createIndUI];
    }else{
        [self createUI];
    }
}

//独立图库
- (void)createIndUI{
    OneFourViewController *vc = [[OneFourViewController alloc]init];
    vc.view.frame = CGRectMake(0, 64+30, KScreenWidth, KScreenHeight-64-49-30);
    vc.view.backgroundColor = [UIColor yellowColor];
    vc.flag = 0;
    [vc addTestViewWithView];
    [vc addScrollViewWithimage:@[@"",@"",@""] url:@[@"",@"",@""]];
    vc.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"QuestBank" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSInteger jzNum = [[DefaultManager getValueOfKey:KJZLX]integerValue];
    NSDictionary *jzDict = [[NSDictionary alloc]init];
    if (jzNum < 5) {
        jzDict = array[0][jzNum-1];
    }else{
        jzDict = array[1][jzNum-7];
    }
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 30)];
    UILabel *label = [MyControl labelWithTitle:jzDict[@"type"] fram:CGRectMake(0, 0, KScreenWidth, 30) color:KColorSystem fontOfSize:14 numberOfLine:1];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    [self.view addSubview:topView];
    [self.view addSubview:vc.view];
}

//非独立题库
- (void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 30)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    //滚动视图上的按钮
    _btnName = @[@"科目一",@"科目二",@"科目三",@"科目四",@"拿本后"];
    CGFloat width = (KScreenWidth/5);
    for (int i = 0; i < _btnName.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 30)];
        [btn setTitle:_btnName[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            btn.selected = YES;
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:KColorRGB(19, 153, 229) forState:UIControlStateSelected];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(scrolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    _scrollView.contentSize = CGSizeMake(_btnName.count*width, 30);
    _bottmLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 28, width-10, 2)];
    _bottmLabel.backgroundColor = KColorRGB(19, 153, 229);
    [_scrollView addSubview:_bottmLabel];
    
    [self addPageView];
}

//添加视图控制器
- (void)addPageView{
    _viewCtrls = [[NSMutableArray alloc]init];
    for (int i = 0; i < 4; i++) {
        if (i == 0 || i == 3) {
            OneFourViewController *vc = [[OneFourViewController alloc]init];
            vc.flag = i;
            [vc addTestViewWithView];
            [vc addScrollViewWithimage:@[@"",@"",@""] url:@[@"",@"",@""]];
            vc.delegate = self;
            [_viewCtrls addObject:vc];
        }else if (i == 1 || i == 2){
            TwoThreeViewController *vc = [[TwoThreeViewController alloc]init];
            vc.flag = i;
            vc.delegate = self;
            [_viewCtrls addObject:vc];
        }
    }
     JZViewController *vc = [[JZViewController alloc]init];
    vc.delegate = self;
    [_viewCtrls addObject:vc];
    //视图控制器
    _pageViewCtrl = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewCtrl setViewControllers:@[_viewCtrls[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageViewCtrl.delegate = self;
    _pageViewCtrl.dataSource = self;
    _pageViewCtrl.view.frame = CGRectMake(0, 64+30, KScreenWidth, KScreenHeight-64-30-49);
    [self.view addSubview:_pageViewCtrl.view];
}

//重写Set方法
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    for (int i = 0; i < _btnName.count; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
        if (i == currentIndex) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            CGFloat x = btn.frame.origin.x;
            CGRect rect = _bottmLabel.frame;
            rect.origin.x = x+5;
            _bottmLabel.frame =rect;
        }else{
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}
//滚动视图按钮点击事件
- (void)scrolBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    [_pageViewCtrl setViewControllers:@[_viewCtrls[index]] direction:index<_currentIndex animated:YES completion:^(BOOL finished) {
        
    }];
    self.currentIndex = index;
}

//返回当前页的下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [_viewCtrls indexOfObject:viewController];
    if (index == _viewCtrls.count-1) {
        return nil;
    }
    return _viewCtrls[index+1];
}

//返回当前页的前一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [_viewCtrls indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return _viewCtrls[index-1];
}

//滑动界面时
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    UIViewController *vc = pageViewController.viewControllers[0];
    self.currentIndex = [_viewCtrls indexOfObject:vc];
}

- (void)doPushWithVc:(UIViewController *)vc{
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doPush:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
