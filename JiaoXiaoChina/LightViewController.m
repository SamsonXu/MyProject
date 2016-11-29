//
//  LightViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "LightViewController.h"
#import "LightCollectController.h"
@interface LightViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    UIScrollView *_scrollView;
    NSArray *_btnName;
    UILabel *_bottmLabel;
    UIPageViewController *_pageViewCtrl;
    NSMutableArray *_viewCtrls;
    NSInteger _currentIndex;
}
@end

@implementation LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI{
    
    self.title = @"灯光语音模拟";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    //滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 30)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    //滚动视图上的按钮
    _btnName = @[@"灯光模拟",@"语音模拟"];
    CGFloat width = (KScreenWidth/2);
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
    for (int i = 0; i < 2; i++) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (KScreenWidth-4)/4;
        flow.itemSize = CGSizeMake(width, width);
        flow.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        flow.minimumLineSpacing = 1;
        flow.minimumInteritemSpacing = 1;
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        LightCollectController *vc = [[LightCollectController alloc]initWithCollectionViewLayout:flow];
        [_viewCtrls addObject:vc];
    }
    //视图控制器
    _pageViewCtrl = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewCtrl setViewControllers:@[_viewCtrls[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageViewCtrl.delegate = self;
    _pageViewCtrl.dataSource = self;
    _pageViewCtrl.view.frame = CGRectMake(0, 64+30, KScreenWidth, KScreenHeight-64-30);
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

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
