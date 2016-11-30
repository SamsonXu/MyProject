//
//  AppDelegate.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "AnswerModel.h"
#import "LeftScrollViewController.h"
#import "FirstLoginController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#define KSize [UIScreen mainScreen].bounds.size
@interface AppDelegate ()<UIScrollViewDelegate,WXApiDelegate,UMSocialUIDelegate>
{
    //夜间模式
    UIView *_nightView;
    //首次进入欢迎界面
    UIScrollView *_scrollView;
    UIPageControl *_pageCtrl;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //向微信注册
    [WXApi registerApp:@"wx131263b4d22c5d4d" withDescription:@"demo 2.0"];
    [UMSocialData setAppKey:@"574d354067e58e201d0003dd"];
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxa5f1e292bb056629" appSecret:@"478a0545374e1882f9b090e133d09aef" url:@"http://www.umeng.com/social"];
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"140879341"
                                              secret:@"8dd20e9ea209d5932e77e080901e2fd6"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105391013" appKey:@"DsApbpzISN5RKdtq" url:@"http://www.umeng.com/social"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //网络请求数据
    if ([DefaultManager getValueOfKey:@"token"]) {
        [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlInfo parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {
            NSDictionary *dict = responseObject[@"data"];
            NSString *imgUrl = dict[@"headimg"];
            UIImage *image;
            if (imgUrl.length == 0) {
                image = [UIImage imageNamed:@"f0"];
            }else{
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            }
            [MyControl writhImageToFileWith:image];
            [userDefaults setObject:dict[@"is_cb"] forKey:KJZLX];
            [userDefaults setObject:dict forKey:@"userInfo"];
            [userDefaults synchronize];
        } failBlock:^{
            
        }];

    }else{
        if (![DefaultManager getValueOfKey:KJZLX]) {
            [userDefaults setObject:@"1" forKey:KJZLX];
            [userDefaults synchronize];
            [DefaultManager createQuestionBase];
        }
    }
    _nightView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _nightView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    _nightView.userInteractionEnabled = NO;
    if ([[DefaultManager getValueOfKey:@"nightModel"] isEqualToString:@"yes"]) {
        [self.window addSubview:_nightView];
        [self.window bringSubviewToFront:_nightView];
    }
    [userDefaults addObserver:self forKeyPath:@"nightModel" options:NSKeyValueObservingOptionNew context:nil];
    UIView *nightView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    nightView.backgroundColor = [UIColor blackColor];
    nightView.alpha = 0.3;
    [self.window addSubview:nightView];
    [self.window bringSubviewToFront:nightView];
    
    if (![DefaultManager getValueOfKey:@"hasCome"]) {
        [self loginFirst];
    }else{
        [self loginAgain];
    }
    return YES;
}

//夜间模式
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSString *str = change[@"new"];
    if ([str isEqualToString:@"no"]) {
        [_nightView removeFromSuperview];
    }else if ([str isEqualToString:@"yes"]){
        [self.window addSubview:_nightView];
        [self.window bringSubviewToFront:_nightView];
    }
}

- (void)loginFirst{
    FirstLoginController *vc = [[FirstLoginController alloc]init];
    self.window.rootViewController = vc;
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
    sideMenuViewController.scaleContentView = YES;;
    self.window.rootViewController = sideMenuViewController;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if ([url.host isEqualToString:@"Pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"safepay"]){
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"comback:%@",resultDic);
            NSString *strTitle = @"报名成功";
            NSString *strMsg = @"确定";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
        

    }else{
        [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    return YES;
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

//微信回调
- (void)onResp:(BaseResp *)resp {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
