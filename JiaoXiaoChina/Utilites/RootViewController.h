//
//  RootViewController.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UMSocialUIDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _currentPage;
    UIScrollView *_bootmScrollView;
    UIAlertController *_alertCtrl;
}

//创建视图/tableView
- (void)createUI;
//请求数据
- (void)requestData;
//导航栏按钮
- (void)addBtnWithTitle:(UILabel *)titleLabel imageName:(NSString *)imageName navBtn:(NSString *)navBtn;
//导航栏按钮点击事件
- (void)leftClick:(UIButton *)btn;
- (void)rightClick:(UIButton *)btn;
//刷新操作
- (void)addRefreshHasHeader:(BOOL)header hasFooter:(BOOL)footer;
//下拉刷新
- (void)refresh;
//上拉加载
- (void)loadMore;
//弹出提示框
- (void)showMessageWithTitle:(NSString *)title;
//创建视图/scrollView
- (void)createScrollView;
//提示框
- (void)showAlertViewWith:(NSArray *)titles sel:(SEL)sel;
@end
