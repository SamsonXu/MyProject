//
//  WebViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/28.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UMSocialUIDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
    UIProgressView *_progressView;//加载进度条
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.navigationItem.title = _navTitle;
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:_webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    _progressView.backgroundColor = KColorSystem;
    [_webView addSubview:_progressView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _progressView.progress = 0.5;
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIView animateWithDuration:0.5 animations:^{
        _progressView.progress = 1.0;
    } completion:^(BOOL finished) {
        _progressView.hidden = YES;
        [_progressView removeFromSuperview];
    }];
    
}

- (void)leftClick:(UIButton *)btn{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightClick:(UIButton *)btn{
    KWS(ws);
    [MyControl UMSocialWithTitle:_navTitle url:_url ws:ws];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
