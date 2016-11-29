//
//  TopicView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TopicView.h"
#import "TopicTableView.h"
#import "StarView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#define KWidth self.frame.size.width
#define KHeight self.frame.size.height
@interface TopicView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;//题目数组
    TopicTableView *_tableView;//显示题目的tableView
    UIView *_view;//头部视图
    NSMutableArray *_hadAnsArray;//答题结果数组
    AVPlayerViewController *_newPlayerVC;//视频播放控制器
    //记录当前对错
    NSMutableArray *_showAnswerArr;
    //播放视频
    AVPlayer *_player;
    //多选按钮
    UIButton *_mulBtn;
    //多选数组
    NSMutableArray *_mulArr;
    NSInteger _currentItem;//当前所在页
}
@end

@implementation TopicView

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array{
    if (self = [super initWithFrame:frame]) {
        self.font = 14;
        _currentPage = 0;
        _currentItem = 0;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = @{KTrue:[NSString stringWithFormat:@"%d",0],KFaults:[NSString stringWithFormat:@"%d",0]};
        [userDefaults setObject:dict forKey:KTrueFaults];
        [userDefaults synchronize];
        _dataArray = [[NSArray alloc]initWithArray:array];
        _hadAnsArray = [[NSMutableArray alloc]init];
        _showAnswerArr = [[NSMutableArray alloc]init];
        //值为零，说明未作答
        for (int i = 0; i < _dataArray.count; i++) {
            [_hadAnsArray addObject:[NSString stringWithFormat:@"%d",0]];
            [_showAnswerArr addObject:[NSString stringWithFormat:@"%d",1]];
        }
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.itemSize = CGSizeMake(KWidth, KHeight);
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight) collectionViewLayout:flow];
        _collectView.pagingEnabled = YES;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.backgroundColor = [UIColor whiteColor];
        [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        [self addSubview:_collectView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
     _tableView = [[TopicTableView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStylePlain model:_dataArray[indexPath.row]];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_tableView.model.select_type == 1) {
        _mulArr = [[NSMutableArray alloc]init];
        _mulBtn = [MyControl buttonWithFram:CGRectMake(40, KHeight-100, KWidth-80, 40) title:@"提交" imageName:nil];
        [_mulBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mulBtn.layer.cornerRadius = 5;
        _mulBtn.backgroundColor = KColorSystem;
        [_mulBtn addTarget:self action:@selector(mulBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableView addSubview:_mulBtn];
    }else{
        _mulBtn.selected = NO;
        _mulArr = nil;
    }
    _currentItem = indexPath.item;
    [cell.contentView addSubview:_tableView];
    return cell;
}

- (void)mulBtnClick:(UIButton *)btn{
    if (_mulArr.count < 2) {
        [self.delegate showMulViewWith:@[@"请至少选择两个选项",@"确定"]];
        return;
    }else{
        AnswerModel *model = _tableView.model;
        [MyControl sortArrayWith:_mulArr];
        [DefaultManager removeDidQuestion:model.pid];
        [_hadAnsArray replaceObjectAtIndex:_currentItem withObject:_mulArr];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:KTrueFaults]];
        NSInteger trueNum = [dict[KTrue] integerValue];
        NSInteger faults = [dict[KFaults] intValue];
        NSArray *ansArr = [model.answer componentsSeparatedByString:@","];

        if ([_mulArr isEqual:ansArr]) {
            trueNum++;
            [self.delegate changeColorWithNum:_currentItem right:YES];
            [self.delegate changeNumOfItem:1];
            if (_remove) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:KWrong]];
                [array removeObjectAtIndex:_currentItem];
                [userDefaults setObject:array forKey:KWrong];
            }
            [NSThread sleepForTimeInterval:0.2];
            [_collectView scrollRectToVisible:CGRectMake((_currentPage+1)*KWidth, 0, KWidth, KHeight) animated:YES];
            _currentPage++;
            [self.delegate changePage:_currentPage];
            
        }else{
            faults++;
            [self.delegate changeColorWithNum:_currentItem right:NO];
            [_showAnswerArr replaceObjectAtIndex:_currentItem withObject:[NSString stringWithFormat:@"%d",0]];
            [DefaultManager addWrongQuestion:model.pid];
            [self.delegate changeNumOfItem:0];
            if (self.isTest) {
                [NSThread sleepForTimeInterval:0.2];
                [_collectView scrollRectToVisible:CGRectMake((_currentPage+1)*KWidth, 0, KWidth, KHeight) animated:YES];
                _currentPage++;
                [self.delegate changePage:_currentPage];
            }
        }
        [dict setObject:[NSString stringWithFormat:@"%ld",trueNum] forKey:KTrue];
        [dict setObject:[NSString stringWithFormat:@"%ld",faults] forKey:KFaults];
        [userDefaults setObject:dict forKey:KTrueFaults];
        [userDefaults synchronize];
        [_tableView reloadData];
    }
    btn.selected = YES;
    btn.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.showAns) {
        return 2;
    }
    
    if ([_showAnswerArr[_currentItem] integerValue] == 1) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    
    if (_tableView.model.lx == 1) {
        return 2;
    }else{
        AnswerModel *model = _tableView.model;
        NSMutableArray *array = [NSMutableArray arrayWithArray:[model.detail componentsSeparatedByString:@",|,"]];
        for (NSString *str in array) {
            if (str.length == 0) {
                [array removeObject:str];
            }
        }
        return array.count;
    }
}

//头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _view = [[UIView alloc]initWithFrame: CGRectMake(0, 0, KWidth, 10)];
    AnswerModel *model = _tableView.model;
    //题目
    UILabel *label = [MyControl labelWithTitle:[NSString stringWithFormat:@"           %@",model.title] fram:CGRectMake(0, 0, 0, 0) fontOfSize:self.font+2 numberOfLine:2];
    CGSize size = [MyControl getSizeWithString:model.title font:label.font size:CGSizeMake(tableView.frame.size.width-20, 200)];
    [label setFrame:CGRectMake(10, 10, KWidth-20, size.height)];
    label.numberOfLines = 0;
    UILabel *queLabel = [MyControl setLineSpaceWithLabel:label];
    [_view addSubview:queLabel];
    //判断题型
    NSString *typeStr;
    if (model.lx == 0) {
        if (model.select_type == 0) {
            typeStr = @"单选";
        }else if (model.select_type == 1){
            typeStr = @"多选";
        }
    }else if (model.lx == 1){
        typeStr = @"判断";
    }
    //显示题型
    UILabel *typeLabel = [MyControl labelWithTitle:typeStr fram:CGRectMake(10, 0, 30, 20) color:[UIColor whiteColor] fontOfSize:12 numberOfLine:1];
    typeLabel.backgroundColor = KColorSystem;
    typeLabel.layer.masksToBounds = YES;
    typeLabel.layer.cornerRadius = 5;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [label addSubview:typeLabel];
    //显示图片
    UIImage *image;
    if (model.pic.length > 0) {
        image = [UIImage imageNamed:[model.pic substringFromIndex:31]];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImageWithTap:)];
    [imageView addGestureRecognizer:tap];
    imageView.userInteractionEnabled = YES;
    [_view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_view);
        make.width.mas_equalTo(image.size.width);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.height.mas_equalTo(image.size.height);
    }];
    
    //显示视频
    if (model.shipingmp.length > 0) {
        NSArray *array = [[model.shipingmp substringFromIndex:27] componentsSeparatedByString:@"."];
        NSString *path = [[NSBundle mainBundle]pathForResource:array[0] ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _newPlayerVC = [[AVPlayerViewController alloc]init];
        //根据url创建新的AVPlayer对象，设置成播放视频的player
        _player = [AVPlayer playerWithURL:url];
        _newPlayerVC.player = _player;
        _newPlayerVC.showsPlaybackControls = NO;
        [_player play];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishPlayMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_view addSubview:_newPlayerVC.view];
        CGFloat width = KWidth-40;
        [_newPlayerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_view);
            make.width.mas_equalTo(width);
            make.top.equalTo(label.mas_bottom).offset(10);
            make.height.mas_equalTo(width/16*8);
        }];

    }else if (_newPlayerVC){
        _newPlayerVC = nil;
    }
        _view.backgroundColor = [UIColor whiteColor];
    _view.frame = CGRectMake(0, 0, KWidth, CGRectGetMaxX(imageView.frame));
    if (section == 0) {
        return _view;
    }else{
        return nil;
    }
}

- (void)finishPlayMovie:(NSNotificationCenter *)notification{
    
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    AnswerModel *model = _tableView.model;
    
    UILabel *label = [MyControl labelWithTitle:[NSString stringWithFormat:@"           %@",model.title] fram:CGRectMake(0, 0, 0, 0) fontOfSize:self.font+2 numberOfLine:0];
    CGSize size = [MyControl getSizeWithString:model.title font:label.font size:CGSizeMake(tableView.frame.size.width-20, 200)];
    [label setFrame:CGRectMake(10, 10, KWidth-20, size.height)];
    UILabel *newLabel = [MyControl setLineSpaceWithLabel:label];
    NSInteger labelHeight = newLabel.frame.size.height;
    
    CGFloat height;
    if (section == 1) {
        return 10;
    }
    
    if (model.pic.length > 0) {
        UIImage *image = [UIImage imageNamed:[model.pic substringFromIndex:31]];
        height = image.size.height + labelHeight + 20 +20;
    }else if (model.shipingmp.length > 0){
        height = (KWidth-40)/16*8 + labelHeight + 20 + 10;
    }else{
        height = labelHeight + 20 ;
    }
    
    if (height > 50) {
        return height;
    }else{
        return 50;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerModel *model = _tableView.model;
    if (indexPath.section == 0) {
        AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
        cell.leftLabel.text = [NSString stringWithFormat:@"%c",(char)('A'+indexPath.row)];
        cell.leftLabel.backgroundColor = KColorSystem;
        cell.leftLabel.clipsToBounds = YES;
        cell.leftLabel.layer.cornerRadius = 10;
        
        if (_tableView.model.lx == 0) {//选择题
            cell.mainLabel.text = [MyControl getAnswerWithString:_tableView.model.detail][indexPath.row];
        }else if(_tableView.model.lx == 1){//判断题
            if (indexPath.row == 0) {
                cell.mainLabel.text = @"错误";
            }else if(indexPath.row == 1) {
                cell.mainLabel.text = @"正确";
            }
        }
        cell.mainLabel.font = [UIFont systemFontOfSize:self.font+2];
        //显示答案对错
        //多选
        if (model.select_type == 1) {
            if (_mulBtn.selected) {
                cell.iconImageView.hidden = NO;
                NSArray *arr = [model.answer componentsSeparatedByString:@","];
                NSMutableArray *arr2 = [NSMutableArray arrayWithArray:@[@"0",@"1",@"2",@"3"]];
                for (NSString *str in arr) {
                    if (str.integerValue == indexPath.row) {
                        cell.iconImageView.image = [UIImage imageNamed:@"answer_cell_option_bg_yes"];
                        cell.mainLabel.textColor = [UIColor greenColor];
                        [arr2 removeObject:str];
                    }
                }
                NSMutableArray *wrongArr = [[NSMutableArray alloc]init];
                for (NSString *str in arr2) {
                    for (NSString *muStr in _mulArr) {
                        if ([str isEqualToString:muStr]) {
                            [wrongArr addObject:str];
                        }
                    }
                }
                
                for (NSString *str in wrongArr) {
                    if (str.integerValue == indexPath.row) {
                        cell.iconImageView.image = [UIImage imageNamed:@"answer_cell_option_bg_no"];
                        cell.mainLabel.textColor = [UIColor redColor];
                    }
                }
            }else if ([_hadAnsArray[_currentItem] integerValue] == 0) {
                for (NSString *str in _mulArr) {
                    if (str.integerValue == indexPath.row) {
                        cell.leftLabel.backgroundColor = [UIColor grayColor];
                    }
                }
            }
        }else if ([_hadAnsArray[_currentItem] integerValue] != 0) {
            cell.iconImageView.hidden = NO;
            if ([model.answer integerValue] == indexPath.row ) {
                cell.iconImageView.image = [UIImage imageNamed:@"answer_cell_option_bg_yes"];
                cell.mainLabel.textColor = [UIColor greenColor];
            }else if (![[NSString stringWithFormat:@"%ld",model.answer.integerValue+1] isEqualToString:_hadAnsArray[_currentItem]] && indexPath.row == [_hadAnsArray[_currentItem] integerValue]-1) {
                cell.iconImageView.image = [UIImage imageNamed:@"answer_cell_option_bg_no"];
                cell.mainLabel.textColor = [UIColor redColor];
            }
            
        }else{
            
            cell.iconImageView.hidden = YES;
            cell.mainLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    
    //显示答案
    NSString *ide = @"myCell";
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
        UIView *ansView = [UIView new];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *label1 = [MyControl labelWithTitle:@"最佳解释" fram:CGRectMake(10, 0, 80, 20) fontOfSize:self.font];
        UILabel *label2 = [MyControl labelWithTitle:@"难度" fram:CGRectMake(KWidth-180, 0, 40, 20) color:[UIColor grayColor] fontOfSize:self.font numberOfLine:1];
        StarView *starView = [[StarView alloc]initWithFrame:CGRectMake(KWidth-140, 0, 100, 20)];
        [starView setStarNum:model.nandu];
        [ansView addSubview:starView];
        UILabel *label3 = [MyControl labelWithTitle:model.jiehsi fram:CGRectMake(0, 0, 0, 0) fontOfSize:self.font numberOfLine:0];
        CGSize size = [MyControl getSizeWithString:model.jiehsi font:[UIFont systemFontOfSize:self.font] size:CGSizeMake(tableView.frame.size.width-20, 100)];
        label3.frame = CGRectMake(10, 30, size.width, size.height);
        UILabel *label4 = [MyControl setLineSpaceWithLabel:label3];
        [ansView addSubview:label1];
        [ansView addSubview:label2];
        [ansView addSubview:label4];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
        }
        ansView.frame = CGRectMake(0, 0, KWidth, 30+label3.frame.size.height);
        [cell.contentView addSubview:ansView];
        ansView.hidden = NO;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerModel *model = _tableView.model;
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1){
        UILabel *label = [MyControl labelWithTitle:model.jiehsi fram:CGRectMake(0, 0, 0, 0) fontOfSize:self.font numberOfLine:0];
        CGSize size = [MyControl getSizeWithString:model.jiehsi font:label.font size:CGSizeMake(tableView.frame.size.width-20, 200)];
        [label setFrame:CGRectMake(10, 10, KWidth-20, size.height)];
        UILabel *newLabel = [MyControl setLineSpaceWithLabel:label];
        return newLabel.frame.size.height + 40;
        
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerModel *model = _tableView.model;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //存储答题选项
    if (_mulBtn.selected) {

    }
    if ([_hadAnsArray[_currentItem] integerValue] != 0) {
        return;
    }else if (_mulArr){
        NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row];
        BOOL hasSelect = YES;
        for (NSInteger i = _mulArr.count; i > 0 ; i--) {
            NSString *muStr = _mulArr[i-1];
            if ([muStr isEqualToString:str]) {
                [_mulArr removeObject:muStr];
                hasSelect = NO;
            }
        }
        if (hasSelect) {
            [_mulArr addObject:str];
        }
        
    }else{
        [_hadAnsArray replaceObjectAtIndex:_currentItem withObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    }
    //存储答题对错数量
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:KTrueFaults]];
    NSMutableArray *trueArr = [NSMutableArray arrayWithArray:[userDefaults objectForKey:KTrue]];
    NSMutableArray *faultsArr = [NSMutableArray arrayWithArray:[userDefaults objectForKey:KFaults]];
    NSInteger trueNum = [dict[KTrue] integerValue];
    NSInteger faults = [dict[KFaults] intValue];
    if (_mulArr) {
        
    }else if ([_hadAnsArray[_currentItem] intValue] == model.answer.integerValue+1) {
        trueNum++;
        [trueArr addObject:[NSString stringWithFormat:@"%d",model.pid]];
        [self.delegate changeColorWithNum:_currentItem right:YES];
        [self.delegate changeNumOfItem:1];
        if (_remove) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:KWrong]];
            [array removeObjectAtIndex:_currentItem];
            [userDefaults setObject:array forKey:KWrong];
        }
            [NSThread sleepForTimeInterval:0.2];
            [_collectView scrollRectToVisible:CGRectMake((_currentPage+1)*KWidth, 0, KWidth, KHeight) animated:YES];
            _currentPage++;
            [self.delegate changePage:_currentPage];
        
    }else{
        faults++;
        [faultsArr addObject:[NSString stringWithFormat:@"%d",model.pid]];
        [self.delegate changeColorWithNum:_currentItem right:NO];
        [_showAnswerArr replaceObjectAtIndex:_currentItem withObject:[NSString stringWithFormat:@"%d",0]];
        [DefaultManager addWrongQuestion:model.pid];
        [self.delegate changeNumOfItem:0];
        if (self.isTest) {
            [NSThread sleepForTimeInterval:0.2];
            [_collectView scrollRectToVisible:CGRectMake((_currentPage+1)*KWidth, 0, KWidth, KHeight) animated:YES];
            _currentPage++;
            [self.delegate changePage:_currentPage];
        }
    }
    [dict setObject:[NSString stringWithFormat:@"%ld",trueNum] forKey:KTrue];
    [dict setObject:[NSString stringWithFormat:@"%ld",faults] forKey:KFaults];
    [userDefaults setObject:faultsArr forKey:KFaults];
    [userDefaults setObject:dict forKey:KTrueFaults];
    [userDefaults synchronize];
    [DefaultManager removeDidQuestion:model.pid];
    [tableView reloadData];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    _newPlayerVC = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page =  scrollView.contentOffset.x/KWidth;
    self.currentPage = page;
    [self.delegate changePage:page];
}
//显示大图
- (void)showBigImageWithTap:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight+64)];
    backView.backgroundColor = [UIColor blackColor];
    //添加手势
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSmallImageWithTap:)];
    [backView addGestureRecognizer:backTap];
    UIImage *image = imageView.image;
    CGFloat height = image.size.height * (float)KWidth/image.size.width;
    if (height > KHeight) {
        height = KHeight;
    }
    UIImageView *midImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, KWidth, 0)];
    midImageView.image = image;
    [backView addSubview:midImageView];
    [UIView animateWithDuration:1 animations:^{
        CGRect rect = midImageView.frame;
        rect.size.height = height;
        rect.origin.y = _tableView.center.y-height/2;
        midImageView.frame = rect;
    }];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:backView];
}

//退出大图
- (void)showSmallImageWithTap:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 0;
    }];
}

//显示答案解释
- (void)showAns:(BOOL)show{
    self.showAns = show;
    [_tableView reloadData];
}
//改变字体大小
- (void)changeFontWithNum:(NSInteger)num{
    self.font = num;
    [_tableView reloadData];
}
@end
