//
//  MoiveViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "MoiveViewController.h"
#import "MoiveManagerController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MoiveViewController ()
{
    UIProgressView *_progressView;
    AVPlayerViewController *_moviePlayerVc;
    //视频文件名称
    NSString *_videoName;
    MPMoviePlayerViewController *_playerVC;
}
@end

@implementation MoiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.title = _model.title;
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    //视频背景
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 200)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.pic_url] placeholderImage:[UIImage imageNamed:@"jxzg_bg"]];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    //下载/播放按钮
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:nil];
    [btn setBackgroundImage:[UIImage imageNamed:@"video_icon_ready"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"video_icon_play"] forState:UIControlStateSelected];
    NSArray *array = [_model.video_url componentsSeparatedByString:@"/"];
    _videoName = [array lastObject];
    NSString *labelStr = @"视频未下载，请前往管理页面下载";
    BOOL hasFile = [[DBManager shareManager]hasFileWithPath:_videoName];
    if (hasFile) {
        btn.selected = YES;
        labelStr = @"视频已下载，点击播放";
    }
    [imageView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.height.with.mas_equalTo(40);
    }];
    //提示文字
    UILabel *label = [MyControl labelWithTitle:labelStr fram:CGRectMake(0, 140, KScreenWidth, 20) fontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    //进度条
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake( 0, 64+198, KScreenWidth, 2)];
    _progressView.hidden = YES;
    [self.view addSubview:_progressView];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 264, KScreenWidth, KScreenHeight-264)];
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.url]]];
    [self.view addSubview:webView];
}

- (void)btnClick:(UIButton *)btn{
    if (!btn.selected) {
        
    }else{
        NSString *documentStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [documentStr stringByAppendingPathComponent:_videoName];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        _moviePlayerVc = [[AVPlayerViewController alloc]init];
        _moviePlayerVc.player = [AVPlayer playerWithURL:url];
        [_moviePlayerVc.player play];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishPlayMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [self presentViewController:_moviePlayerVc animated:YES completion:nil];
    }
}

- (void)finishPlayMovie:(NSNotificationCenter *)notification{
    [_moviePlayerVc dismissViewControllerAnimated:YES completion:nil];
    _moviePlayerVc = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    double value = [change[@"new"] doubleValue];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        _progressView.progress = value;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIWebView *_webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    [cell.contentView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 600;
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
