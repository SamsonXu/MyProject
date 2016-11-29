//
//  AnswerViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/25.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "AnswerViewController.h"
#import "SheetView.h"
#import "ScroeViewController.h"
#import "TopicView.h"
@interface AnswerViewController ()<SheetViewDelegate,TopicViewDelegate,UIAlertViewDelegate>
{
    //抽屉视图背景
    UIView *_backView;
    UIButton *_lastBtn;
    
    //图片数据源
    NSArray *_modelImages;
    UILabel *_comLabel;
    //加载答题界面的滚动视图
    TopicView *_topicView;
    //抽屉视图
    SheetView *_sheetView;
    //抽屉视图按钮
    UIButton *_currentBtn;
    //收藏按钮
    UIButton *_colBtn;
    //答题计时器
    NSTimer *_timer;
    //显示时间
    NSInteger _time;
    //用时
    NSInteger _useTime;
    //已经解答的题
    NSInteger _hasSolve;
    //答对题目数
    NSInteger _trueAns;
    NSUserDefaults *_defaults;
}
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    [self createUI];
    //显示抽屉界面
    [self createSheetView];
    //显示设置页面
    [self showSetView];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    _trueAns = 0;
    _useTime = 0;
    if (_type !=6 && _type != 7) {
        [self showPracticeItems];
    }else{
        [self showTestItems];
    }
}

//练习导航栏视图
- (void)showPracticeItems{
    NSString *str = [NSString stringWithFormat:@"1/%ld",_modelArr.count];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSArray *images = @[@"nav_more",@"nav_share",@"collect",@"nav_index"];
    NSArray *titles = @[@"更多",@"考考朋友",@"收藏",str];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [MyControl navBtnWithFram:CGRectMake(0, 0, 55, 44) Title:titles[i] image:images[i]];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 3) {
            _currentBtn = btn;
        }
        if (i == 2) {
            _colBtn = btn;
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [items addObject:item];
    }
    self.navigationItem.rightBarButtonItems = items;
}

//考试导航栏视图
- (void)showTestItems{
    NSString *str;
    if (_number == 1) {
        str = @"45:00";
        _time = 45*60;
    }else if (_number == 2){
        str = @"30:00";
        _time = 30*60;
    }
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSArray *images = @[@"nav_more",@"nav_submit",@"collect",@"nav_time"];
    NSArray *titles = @[@"更多",@"交卷",@"收藏",str];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [MyControl navBtnWithFram:CGRectMake(0, 0, 55, 44) Title:titles[i] image:images[i]];
        btn.tag = 100 + i;
        if (i == 2) {
            _colBtn = btn;
        }
        if (i == 3) {
            _currentBtn = btn;
        }
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [items addObject:item];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    self.navigationItem.rightBarButtonItems = items;
    _topicView.isTest = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSString *trueNum = change[@"new"][KTrue];
    NSString *faults = change[@"new"][KFaults];
    NSInteger num = _modelArr.count-trueNum.integerValue-faults.integerValue;
    [_sheetView changeNumberWithNum:@[trueNum,faults,[NSString stringWithFormat:@"%ld",num]]];
}

//倒计时
- (void)countDown{
    if (_time == 0) {
        [self showAlertViewWith:@[@"温馨提示",@"答题时间已到",@"继续答题",@"交卷"] sel:@selector(alertBtnClick)];
        return;
    }
    _time--;
    _useTime++;
    UILabel *label = _currentBtn.subviews[1];
    label.text = [NSString stringWithFormat:@"%ld:%02ld",_time/60,_time%60];
}

//设置数据源数据
- (void)requestData{
    _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults addObserver:self forKeyPath:KTrueFaults options:NSKeyValueObservingOptionNew context:nil];
    if (_number == 4) {
        _number = 2;
    }
    NSInteger cb = [[_defaults objectForKey:KJZLX]integerValue];
    NSArray *array = [[DBManager shareManager]selectDataWithCb:cb];
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    if (cb < 4) {
        transArray = [[DBManager shareManager]selectDataWithTk:_number arr:array];
    }else{
        transArray = [array mutableCopy];
    }
    
    if (_type == 1) {
        _modelArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < transArray.count; ) {
            int index = arc4random()%transArray.count;
            [_modelArr addObject:transArray[index]];
            [transArray removeObjectAtIndex:index];
        }
    }else if (_type == 2){
        _modelArr = [[NSMutableArray alloc]init];
        for (AnswerModel *model in transArray) {
            if (model.fid == _zj) {
                [_modelArr addObject:model];
            }
        }
    }else if (_type == 3){
        for (int i = 0; i < transArray.count-1; i++) {
            for (int j = 0; j < transArray.count-i-1; j++) {
                if ([transArray[j] nandu] > [transArray[j+1] nandu]) {
                    AnswerModel *model = transArray[j];
                    transArray[j] = transArray[j+1];
                    transArray[j+1] = model;
                }
            }
        }
        NSRange range = NSMakeRange(0, 100);
        _modelArr = [NSMutableArray arrayWithArray:[transArray subarrayWithRange:range]];
    }else if (_type == 4){
        _modelArr = [[NSMutableArray alloc]init];
        NSArray *array = [DefaultManager getQuestionBase];
        for (NSString *num in array) {
            for (AnswerModel *model in transArray) {
                if (num.integerValue == model.pid) {
                    [_modelArr addObject:model];
                }
            }
        }
    }else if (_type == 5){
        _modelArr = [transArray mutableCopy];
    }else if (_type == 6){
        _modelArr = [[NSMutableArray alloc]init];
        NSInteger num;
        if (self.number == 1) {
            num = _topicNum;
        }else if (_number == 2){
            num = 50;
        }
        for (int i = 0; i < num; i++) {
            int index = arc4random()%transArray.count;
            [_modelArr addObject:transArray[index]];
            [transArray removeObjectAtIndex:index];
        }
        _hasSolve = _modelArr.count;
    }else if (_type == 8){
        _modelArr = [[NSMutableArray alloc]init];
       NSArray *array = [DefaultManager getWrongQuestion];
        for (AnswerModel *model in transArray) {
            for (NSString *num in array) {
                if (num.integerValue == model.pid) {
                    [_modelArr addObject:model];
                }
            }
        }
    }else if (_type == 9){
        _modelArr = [[NSMutableArray alloc]init];
        NSArray *array = [DefaultManager getCollectQuestion];
        for (AnswerModel *model in transArray) {
            for (NSString *num in array) {
                if (num.integerValue == model.pid) {
                    
                    [_modelArr addObject:model];
                }
            }
        }
    }else if (_type == 10){
        _modelArr = [[NSMutableArray alloc]init];
        for (AnswerModel *model in transArray) {
            if (model.xid.integerValue == _fl+1) {
                [_modelArr addObject:model];
            }
        }
    }
    _topicView = [[TopicView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) withArray:_modelArr];
    _topicView.delegate = self;
    _topicView.remove = _remove;
    [self.view addSubview:_topicView];
}

//返回上一界面
- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    [_defaults removeObserver:self forKeyPath:KTrueFaults context:nil];
}

//导航栏按钮点击事件
- (void)itemClick:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    if (_type !=6 && _type != 7) {
        if (index == 0) {
            _backView.hidden = NO;
        }else if(index == 1){
            
        }else if (index == 3){
            [UIView animateWithDuration:0.5 animations:^{
                _sheetView.frame = CGRectMake(0, 80+64, KScreenWidth, self.view.frame.size.height-80-64);
                _sheetView->_backView.alpha = 0.8;
            }];
        }
    }else{
        if (index == 0) {
            _backView.hidden = NO;
        }else if (index == 1){
            [self showAlertViewWith:@[@"温馨提示",[NSString stringWithFormat:@"您还有%ld道题未做，确定交卷吗？",_hasSolve],@"继续答题",@"交卷"] sel:@selector(alertBtnClick)];
        }
    }
    //点击收藏
    if (index == 2){
        NSString *str1;
        NSString *str2;
        AnswerModel *model = _modelArr[_topicView.currentPage];
        if (btn.selected) {
            btn.selected = NO;
            str1 = @"collect";
            str2 = @"收藏";
            [DefaultManager removeCollectQuestion:model.pid];
        }else{
            btn.selected = YES;
            str1 = @"collect_h";
            str2 = @"已收藏";
            [DefaultManager addCollectQuestion:model.pid];
        }
        UIImageView *imageView = btn.subviews[0];
        UILabel *label = btn.subviews[1];
        imageView.image = [UIImage imageNamed:str1];
        label.text = str2;
    }
}
//交卷弹出提示框
- (void)alertBtnClick{
    [_timer invalidate];
    NSInteger scroe = 100/_modelArr.count*_trueAns;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld",_useTime/60,_useTime%60];
    [DefaultManager addScoreRecoderWithScore:scroe time:timeStr flag:_number num:_topicNum];
    ScroeViewController *vc = [[ScroeViewController alloc]init];
    vc.score = scroe;
    vc.time = timeStr;
    vc.flag = _number;
    vc.num = _topicNum;
    [self.navigationController pushViewController:vc animated:YES];
}
//设置页面
- (void)showSetView{
    
    //弹出视图
    UIView *setView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-220, KScreenWidth, 220)];
    setView.backgroundColor = [UIColor whiteColor];
   
    //左侧label
    NSArray *titles = @[@"展开答案解释",@"考友分析",@"夜间模式",@"字体大小"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [MyControl labelWithTitle:titles[i] fram:CGRectMake(10, 10+50*i, 100, 20) fontOfSize:16];
        [setView addSubview:label];
    }
    
    //显示评论
    _comLabel= [MyControl labelWithTitle:@"评论已显示" fram:CGRectMake(KScreenWidth-160, 60, 80, 20) fontOfSize:14];
    _comLabel.tag = 20;
    [setView addSubview:_comLabel];
   
    //字体大小
    NSArray *fontArray = @[@"A小号",@"A标准",@"A大号"];
    for (int i = 0; i < fontArray.count; i++) {
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(KScreenWidth-210+70*i, 160, 70, 20) title:fontArray[i] imageName:nil tag:54+i];
        [btn addTarget:self action:@selector(setViewClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1) {
            btn.selected = YES;
            _lastBtn = btn;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:12+2*i];
        [btn setTitleColor:KColorSystem forState:UIControlStateSelected];
        [setView addSubview:btn];
    }
    
    //右侧开关
    for (int i = 0; i < 3; i++) {
        UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(KScreenWidth-80, 10+50*i, 60, 20)];
        mySwitch.tag = 30+i;
        if (i == 1) {
            [mySwitch setOn:YES];
        }
        if (i == 2 && [[DefaultManager getValueOfKey:@"nightModel"] isEqualToString:@"yes"]) {
                [mySwitch setOn:YES];
        }
        [mySwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        [setView addSubview:mySwitch];
    }
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _backView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [_backView addSubview:setView];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backHandleClick:)];
    [_backView addGestureRecognizer:tap];
}

//点击屏幕隐藏设置视图
- (void)backHandleClick:(UITapGestureRecognizer *)tap{
    _backView.hidden = YES;
}

//设置视图上按钮点击事件
- (void)setViewClick:(UIButton *)btn{
   
    NSInteger index = btn.tag-50;
    btn.selected = YES;
    _lastBtn.selected = NO;
    _lastBtn = btn;
    if (index == 4 || index == 5 || index == 6){
        
        [_topicView changeFontWithNum:btn.titleLabel.font.pointSize];
        [self.delegate passValue:btn.titleLabel.font.pointSize];
    }
}

//开关点击事件
- (void)switchClick:(UISwitch *)comSwitch{
    NSString *str;
    NSInteger index = comSwitch.tag-30;
    if (index == 0) {
        [_topicView showAns:comSwitch.isOn];
    }else if (index == 1) {
        if (comSwitch.isOn) {
            str = @"评论已显示";
        }else{
            str = @"评论已隐藏";
        }
        _comLabel.text = str;
    }else if (index == 2){
        if (comSwitch.isOn) {
            [DefaultManager addValue:@"yes" key:@"nightModel"];
        }else{
            [DefaultManager addValue:@"no" key:@"nightModel"];
        }
    }
    
}

- (void)createSheetView{
    _sheetView = [[SheetView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, KScreenWidth, self.view.frame.size.height-80) view:self.view number:(int)_modelArr.count];
    if (_type == 6 || _type == 7) {
        _sheetView.frame = CGRectMake(0, KScreenHeight-64, KScreenWidth, self.view.frame.size.height-80);
        _sheetView.isTest = 1;
    }
    _sheetView.delegate = self;
    [self.view addSubview:_sheetView];
}

#pragma mark-----SheetViewDelegate
- (void)sheetViewClick:(NSInteger)index{
    UICollectionView *collectView = _topicView->_collectView;
    collectView.contentOffset = CGPointMake((index)*collectView.frame.size.width, 0);
    _topicView.currentPage = index;
}

//点击题号改变当前题目数
- (void)changeBtnNum:(NSInteger)index{
    if (_type !=6 && _type != 7) {
        UILabel *label = _currentBtn.subviews[1];
        label.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_modelArr.count];
    }
    
    AnswerModel *curtModel = _modelArr[_topicView.currentPage];
    NSArray *colArr = [DefaultManager getCollectQuestion];
    UIImageView *imageView = _colBtn.subviews[0];
    UILabel *label1 = _colBtn.subviews[1];
    for (NSString *num in colArr) {
        if (num.integerValue == curtModel.pid) {
            _colBtn.selected = YES;
            imageView.image = [UIImage imageNamed:@"collect_h"];
            label1.text = @"已收藏";
            return;
        }else{
            _colBtn.selected = NO;
            imageView.image = [UIImage imageNamed:@"collect"];
            label1.text = @"收藏";
        }
    }
}
#pragma mark---TopicViewDelegate
//滑动改变显示的当前题目数
- (void)changePage:(NSInteger)index{
    if (_type !=6 && _type != 7) {
        UILabel *label = _currentBtn.subviews[1];
        label.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_modelArr.count];
    }
    AnswerModel *curtModel = _modelArr[_topicView.currentPage];
    NSArray *colArr = [DefaultManager getCollectQuestion];

    UIImageView *imageView = _colBtn.subviews[0];
    UILabel *label1 = _colBtn.subviews[1];
    
    for (NSString *num in colArr) {
        if (num.integerValue == curtModel.pid) {
            _colBtn.selected = YES;
            imageView.image = [UIImage imageNamed:@"collect_h"];
            label1.text = @"已收藏";
            return;
        }else{
            _colBtn.selected = NO;
            imageView.image = [UIImage imageNamed:@"collect"];
            label1.text = @"收藏";
        }
    }
}

- (void)changeNumOfItem:(BOOL)isTrue{
    if (_hasSolve == 0) {
        return;
    }
    if (isTrue) {
        _trueAns++;
    }
    _hasSolve--;
}

- (void)changeColorWithNum:(NSInteger)num right:(BOOL)right{
    [_sheetView changeColorWithNum:num right:right];
}

- (void)showMulViewWith:(NSArray *)array{
    [self showAlertViewWith:array sel:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
