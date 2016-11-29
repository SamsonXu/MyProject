//
//  MoiveManagerController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "MoiveManagerController.h"
#import "ManagerCell.h"
#import "MoiveViewController.h"
#import "MQLResumeManager.h"
@interface MoiveManagerController ()<ManagerCellDelegate>
{
    NSInteger _currentPage;
    NSIndexPath *_indexPath;
    MQLResumeManager *_manager;
}
@end

@implementation MoiveManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:[MyControl labelWithTitle:@"编辑" fram:CGRectMake(0, 0, 40, 40) color:[UIColor whiteColor] fontOfSize:14 numberOfLine:1] imageName:nil navBtn:KNavBarRight];
    if (self.flag == 1) {
        self.title = @"科目二视频下载管理";
    }else{
        self.title = @"科目三视频下载管理";
    }
    [_tableView registerNib:[UINib nibWithNibName:@"ManagerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _modelArr[indexPath.row];
    NSArray *array = [[_modelArr[indexPath.row] video_url] componentsSeparatedByString:@"/"];
    BOOL hasFile = [[DBManager shareManager]hasFileWithPath:[array lastObject]];
    
    if (hasFile) {
#warning 此处有bug
        cell.downLoadLabel.text = @"未下载";
//        cell.downLoadImage.image = [UIImage imageNamed:@"download_cell_end"];
    }
    [cell.downBtn addTarget:self action:@selector(downLoadClick:) forControlEvents:UIControlEventTouchUpInside];
    _currentPage = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieModel *model = _modelArr[indexPath.row];
    MoiveViewController *vc = [[MoiveViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//点击下载
- (void)downLoadClick:(UIButton *)btn{
    ManagerCell *cell = (ManagerCell *)[[btn superview]superview];
    _indexPath = [_tableView indexPathForCell:cell];
    _currentPage = _indexPath.row;
    MovieModel *model = _modelArr[_indexPath.row];
    if ([cell.downLoadLabel.text isEqualToString:@"未下载"] || [cell.downLoadLabel.text isEqualToString:@"已暂停"]) {
        if (_manager) {
            [_manager cancel];
            _manager = nil;
        }
        NSArray *array = [model.video_url componentsSeparatedByString:@"/"];
        NSString *targetPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[array lastObject]]];
        NSURL *url = [NSURL URLWithString:model.video_url];
        _manager = [MQLResumeManager resumeManagerWithURL:url targetPath:targetPath success:^{
            
            cell.downLoadLabel.text = @"已下载";
            cell.downLoadImage.image = [UIImage imageNamed:@"download_cell_end"];
            cell.downLoadProgress.hidden = YES;
            cell.ramLabel.hidden = YES;
            
        } failure:^(NSError *error) {
                        
        } progress:^(long long totalReceivedContentLength, long long totalContentLength) {
            
            float percent = 1.0 * totalReceivedContentLength / totalContentLength;
            NSString *strPersent = [[NSString alloc]initWithFormat:@"%.f", percent *100];
            cell.downLoadProgress.progress = percent;
            cell.ramLabel.text = [NSString stringWithFormat:@"已下载%@%%", strPersent];
        }];
        //2.启动
        [_manager start];
        cell.downLoadLabel.text = @"正在下载";
        cell.downLoadImage.image = [UIImage imageNamed:@"download_cell_down"];
        cell.downLoadProgress.hidden = NO;
        
    }else if ([cell.downLoadLabel.text isEqualToString:@"正在下载"]){
        [_manager cancel];
        cell.downLoadLabel.text = @"已暂停";
        cell.downLoadImage.image = [UIImage imageNamed:@"download_cell_pause"];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
     ManagerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.downLoadLabel.text isEqualToString:@"未下载"]||[cell.downLoadLabel.text isEqualToString:@"正在下载"]) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieModel *model = _modelArr[_indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ManagerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.downLoadLabel.text = @"未下载";
        cell.downLoadImage.image = [UIImage imageNamed:@"download_cell_begin"];
        cell.ramLabel.hidden = YES;
        cell.downLoadProgress.hidden = YES;
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        NSArray *array = [model.video_url componentsSeparatedByString:@"/"];
        [fileManager removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[array lastObject]]] error:nil];
        cell.editing = NO;
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:YES];
    
    [_tableView setEditing:editing animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    if (!btn.selected) {
         btn.selected = YES;
        UILabel *label = btn.subviews[0];
        label.text = @"完成";
        [self setEditing:YES animated:YES];
    }else{
        btn.selected = NO;
        UILabel *label = btn.subviews[0];
        label.text = @"编辑";
        [self setEditing:NO animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
