//
//  FirstViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "OneFourViewController.h"
#import "TestView.h"
#import "ZXLXViewController.h"
#import "AnswerViewController.h"
#import "PracticeTestViewController.h"
#import "TransionViewController.h"
#import "PictureViewController.h"
#import "StudyRecodViewController.h"
#import "TestRecodViewController.h"
#import "RankingViewController.h"
#import "WebViewController.h"
@interface OneFourViewController ()<UIScrollViewDelegate,TestViewDelegate>
{
    //滚动视图数据源
    NSArray *_imageArray;
    UIScrollView *_scrollView;
    UIImageView *_leftView;
    UIImageView *_midView;
    UIImageView *_rightView;
    NSArray *_urlArray;
    UIPageControl *_pageControl;
    NSString *_topicNum;//话题数
    NSString *_cateid;//话题id
}
@end

@implementation OneFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTestViewWithView];
    [self requestData];
    [self getRiderList];
}

- (void)requestData{
    NSString *aid;
    if (self.flag == 0) {
        aid = @"74";
    }else if (self.flag == 3){
        aid = @"75";
    }
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlAdver1 parameters:@{@"id":aid} sucBlock:^(id responseObject) {

    } failBlock:^{
        
    }];
}

//练习/考试视图
- (void)addTestViewWithView{

    CGFloat y = 146;
    TestView *testView1 = [[TestView alloc]initWithFrame:CGRectMake(0, y+10, KScreenWidth, 141) flag:1];
    testView1.delegate = self;
    [_bootmScrollView addSubview:testView1];
    
    TestView *testView2 = [[TestView alloc]initWithFrame:CGRectMake(0, y+10+141+10, KScreenWidth, 141) flag:2];
    testView2.delegate = self;
    [_bootmScrollView addSubview:testView2];
}

//滚动轮播视图
- (void)addScrollViewWithimage:(NSArray *)image url:(NSArray *)url{
    //拷贝数据
    _dataArray = [image mutableCopy];
    _urlArray = [url mutableCopy];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 458, KScreenWidth, 90)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_bootmScrollView addSubview:_scrollView];
    
    
    
    for (int i = 0; i < _urlArray.count+1; i++) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        UIImageView *imageView = [MyControl imageViewWithFram:CGRectMake(KScreenWidth*i, 0, KScreenWidth, 90) url:_urlArray[i%_urlArray.count]];
        imageView.backgroundColor = [UIColor colorWithWhite:arc4random()%256/255.0 alpha:1];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(KScreenWidth*4, 90);
    _scrollView.delegate = self;
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(100, 457+70, 170, 10)];
    //设置总页数
    _pageControl.numberOfPages=3;
    
    //设置当前显示的页码
    _pageControl.currentPage=0;
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor grayColor];
    //设置当前页码的指示颜色
    _pageControl.currentPageIndicatorTintColor=KColorSystem;
    [_bootmScrollView addSubview:_pageControl];
    _bootmScrollView.contentSize = CGSizeMake(KScreenWidth, 747);
    _currentPage = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loopScroll) userInfo:nil repeats:YES];
    self.lastView = _scrollView;
    [self addRecoderBtn];
}

//定时器调用方法，自动滚动
- (void)loopScroll{
    if(_currentPage<3){
        _currentPage++;
        //设置滚动视图的内容偏移值(显示下一页)
        [_scrollView setContentOffset:CGPointMake(_currentPage*KScreenWidth, 0) animated:YES];
    }else if(_currentPage==3){
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _currentPage=1;
        [_scrollView setContentOffset:CGPointMake(_currentPage*KScreenWidth, 0) animated:YES];
    }
    _pageControl.currentPage=_currentPage%3;
}

//滚动视图上图片触摸事件
- (void)tapClick:(UITapGestureRecognizer *)tap{
    WebViewController *vc = [[WebViewController alloc]init];
    vc.navTitle = @"待添加链接";
    vc.url = @"";
    [self.delegate doPushWithVc:vc];
    self.tabBarController.tabBar.hidden = YES;
}

//滚动视图下方按钮
- (void)addRecoderBtn{
    KWS(ws);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor whiteColor];
    [_bootmScrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.lastView.mas_bottom).offset(10);
        make.left.right.equalTo(ws.view);
        make.height.mas_equalTo(65);
    }];
    NSArray *styImages = @[@"driving_wrong",@"driving_favs",@"driving_shorthand",@"driving_statistics"];
    NSArray *styTitles = @[@"我的错题",@"我的收藏",@"图标速记",@"学习统计"];
    //每个按钮的宽度
    CGFloat width = KScreenWidth/styImages.count;
    UIButton *lastBtn = nil;
    for (int i = 0; i < styImages.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(bootmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [_bootmScrollView addSubview:btn];
        //一排按钮
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastBtn) {
                    make.left.equalTo(ws.view);
            }else{
                    make.left.equalTo(lastBtn.mas_right);
            }
                make.top.bottom.equalTo(view);
                make.width.mas_equalTo(width);
        }];
        //按钮内容
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:styImages[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        //标题
        UILabel *titleLabel = [MyControl labelWithTitle:styTitles[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(btn);
        }];
        lastBtn = btn;
    }
    self.lastView = lastBtn;
}

- (void)getRiderList{
    
    if (self.flag == 0) {
        _cateid = @"2";
    }else if (self.flag == 3){
        _cateid = @"5";
    }
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiderHeadList parameters:@{@"cateid":_cateid} sucBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        _topicNum = responseObject[@"wd_count"];
       [self createRiderViewWith:array];
        
   } failBlock:^{
   }];
}

- (void)createRiderViewWith:(NSArray *)array{
    KWS(ws);
    UIView *backView = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewClick:)];
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.lastView.mas_bottom).offset(10);
        make.left.right.equalTo(ws.view);
        make.height.mas_equalTo(111);
    }];
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backView);
        make.height.mas_equalTo(30);
    }];
    
    NSString *str;
    if (self.flag == 0) {
        str = @"科目一";
    }else if (self.flag == 3){
        str = @"科目四";
    }
    UILabel *label1 = [MyControl labelWithTitle:[NSString stringWithFormat:@"驾考圈-%@",str] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [headView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.centerY.equalTo(headView);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dt_main_web_forward"]];
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.equalTo(ws.view);
        make.height.width.mas_equalTo(20);
    }];
    
    UILabel *label2 = [MyControl labelWithTitle:[NSString stringWithFormat:@"有%@位驾友参与讨论",_topicNum] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [headView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.equalTo(imageView.mas_left);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat width = (KScreenWidth-70)/6;
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(1);
        make.left.right.equalTo(headView);
        make.height.mas_equalTo(width+20);
    }];
    
    UIImageView *lastView = nil;
    for (int i = 0; i < 6; i++) {
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i][@"headimg"]] placeholderImage:[UIImage imageNamed:@""]];
        imageView.layer.cornerRadius = width/2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor yellowColor];
        [bottomView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(10);
            }else{
                make.left.equalTo(bottomView).offset(10);
            }
            make.height.width.mas_equalTo(width);
        }];
        lastView = imageView;
    }
}

- (void)bootmBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    
    if (index == 0 || index == 1) {
        TransionViewController *vc = [[TransionViewController alloc]init];
        vc.flag = index;
        vc.tid = self.flag+1;
        [self.delegate doPushWithVc:vc];
    }else if (index == 2){
        PictureViewController *vc = [[PictureViewController alloc]init];
        [self.delegate doPushWithVc:vc];
    }else if (index == 3){
        StudyRecodViewController *vc = [[StudyRecodViewController alloc]init];
        vc.flag = self.flag+1;
        [self.delegate doPushWithVc:vc];
    }
}

#pragma mark-----scrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //根据偏移值计算出当前显示的界面所在的页码
    _currentPage=scrollView.contentOffset.x/300;
    _pageControl.currentPage=_currentPage%3;
    
    //当显示第4张图片(与第1张图片一样)时，快速切回显示第1张图片(不能加动画)
    if(_currentPage==3){
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }

}

#pragma mark----TestView协议方法
- (void)testViewWithtag:(NSInteger)tag flag:(NSInteger)flag{
    if (flag == 1) {
        if (tag == 0) {
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.type = 1;
            vc.number = self.flag+1;
            [self.delegate doPushWithVc:vc];
        }else if (tag == 1){
            ZXLXViewController *vc = [[ZXLXViewController alloc]init];
            vc.flag = self.flag+1;
            [self.delegate doPushWithVc:vc];
        }else if (tag == 2){
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.number = self.flag+1;
            vc.type = 3;
            [self.delegate doPushWithVc:vc];
        }else if (tag == 3){
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.type = 4;
            vc.number = self.flag+1;
            [self.delegate doPushWithVc:vc];
        }else if (tag == 4){
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.type = 5;
            vc.number = self.flag+1;
            [self.delegate doPushWithVc:vc];
        }
    }else if (flag == 2){
        if (tag == 0) {
            TestRecodViewController *vc = [[TestRecodViewController alloc]init];
            vc.flag = self.flag+1;
            [self.delegate doPushWithVc:vc];
        }else if (tag == 1){
            RankingViewController *vc = [[RankingViewController alloc]init];
            vc.kid = self.flag+1;
            [self.delegate doPushWithVc:vc];
        }else if (tag == 2){
            
        }else if (tag == 3){
            RidersTopicController *vc = [[RidersTopicController alloc]init];
            vc.cateId = @"6";
            [self.delegate doPushWithVc:vc];
        }else if (tag == 4){
            PracticeTestViewController *vc = [[PracticeTestViewController alloc]init];
            vc.flag = self.flag+1;
            [self.delegate doPushWithVc:vc];

        }
    }
}

- (void)backViewClick:(UITapGestureRecognizer *)tap{
    RidersTopicController *vc = [[RidersTopicController alloc]init];
    vc.cateId = _cateid;
    [self.delegate doPushWithVc:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
