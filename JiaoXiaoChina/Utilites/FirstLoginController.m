//
//  FirstLoginController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/17.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "FirstLoginController.h"
#import "LeftScrollViewController.h"
@interface FirstLoginController ()<UIScrollViewDelegate,RESideMenuDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageCtrl;
}
@end

@implementation FirstLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    KWS(ws);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *trueArr = [[NSArray alloc]init];
    NSArray *faultArr = [[NSArray alloc]init];
    [defaults setObject:trueArr forKey:KTrue];
    [defaults setObject:faultArr forKey:KFaults];
    [defaults synchronize];
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(KScreenWidth*3, KScreenHeight);
    [self.view addSubview:_scrollView];
    NSArray *images = @[@"welcome1",@"welcome2",@"welcome3"];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight)];
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        if (i == 2) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comeIn)];
            [imageView addGestureRecognizer:tap];
        }
        
        
    }
    _pageCtrl = [[UIPageControl alloc]init];
    _pageCtrl.numberOfPages = 3;
    [self.view addSubview:_pageCtrl];
    
    [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.equalTo(ws.view.mas_bottom).offset(-20);
    }];
    [DefaultManager addValue:@"has" key:@"hasCome"];
}

- (void)comeIn{
    [self loginAgain];
}

- (void)loginAgain{
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleBlack;
    navBar.barTintColor = KColorRGB(19, 153, 229);
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    MyTabBarController *tabBarCtrl = [MyTabBarController shareTabBar];
    LeftScrollViewController *leftMenuViewController = [[LeftScrollViewController alloc] init];
    if ([DefaultManager getValueOfKey:@"token"]) {
        leftMenuViewController.hasLogin = YES;
    }else{
        leftMenuViewController.hasLogin = NO;
    }
    //创建RESideMenu方法，传入主视图和侧边视图
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:tabBarCtrl leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
    
    sideMenuViewController.menuPreferredStatusBarStyle = 1;
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.3;
    sideMenuViewController.contentViewShadowRadius = 10;
    //设置阴影
    sideMenuViewController.contentViewShadowEnabled = YES;
    //内容视图是否缩小
    sideMenuViewController.scaleContentView = YES;
    [self presentViewController:sideMenuViewController animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/KScreenWidth;
    _pageCtrl.currentPage = currentPage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
