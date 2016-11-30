//
//  TopicDetailViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/17.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "JournalViewController.h"
#import "DetailCell.h"
#import "RiderCellTwo.h"
@interface TopicDetailViewController ()<UITextViewDelegate,RidersCellTwoDelegate>
{
    NSDictionary *_detailDict;
    NSMutableArray *_commentArr;
    NSMutableArray *_favoriteArr;
    JournalModel *_model;
    UIView *_commentView;
    UILabel *_plachLabel;
    NSString *_delComId;//删除评论id
    BOOL _isCommentSecond;//是否为二级评论
    NSString *_replyId;//评论id
}
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _commentArr = [[NSMutableArray alloc]init];
    _favoriteArr = [[NSMutableArray alloc]init];
    [self requestData];
    [self createUI];
}

- (void)requestData{
    
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlTopicDetail1 parameters:@{@"id":_pid} sucBlock:^(id responseObject) {
        KMBProgressHide;
        _detailDict = responseObject[@"data"];
        _model = [[JournalModel alloc]initWithDictionary:responseObject[@"data"] error:nil];
        [_tableView reloadData];
    } failBlock:^{
        KMBProgressHide;
    }];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlTopicDetail2 parameters:@{@"id":_pid} sucBlock:^(id responseObject) {
        
        _favoriteArr = responseObject[@"volist"];
        [_tableView reloadData];
    } failBlock:^{
        
    }];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlTopicDetail4 parameters:@{@"id":_pid} sucBlock:^(id responseObject) {

        _commentArr = [CommentModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
        [_tableView reloadData];
    } failBlock:^{
        
    }];
}

- (void)createUI{
    
    [super createUI];
    self.title = @"话题内容";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 150;
    _tableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-50);
    
    if (_isOthers) {
        [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    }else{
        [self addBtnWithTitle:nil imageName:@"del-2" navBtn:KNavBarRight];
    }
    
    _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentView];
    
    UITextView *textView = [UITextView new];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    textView.tag = 11;
    [_commentView addSubview:textView];
    
    _plachLabel = [MyControl labelWithTitle:@"回复楼主" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    _plachLabel.textColor = [UIColor grayColor];
    [textView addSubview:_plachLabel];
    
    [_plachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textView);
        make.left.equalTo(textView).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_commentView);
        make.left.equalTo(_commentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-100, 30));
    }];
    
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"发表" imageName:nil tag:12];
    [btn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = KColorSystem;
    btn.layer.cornerRadius = 5;
    [_commentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentView).offset(-10);
        make.centerY.equalTo(_commentView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:UIKeyboardTypeDefault];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:UIKeyboardTypeDefault];
}

- (void)commentBtnClick:(UIButton *)btn{

        UITextView *textView = [_commentView viewWithTag:11];
        if (textView.text.length < 2 || textView.text.length > 150) {
            [self showAlertViewWith:@[@"评论字数限制为2~150字",@"确定"] sel:nil];
            
        }else{
            if (_isCommentSecond) {
                _isCommentSecond = NO;

                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlCommentSecond parameters:@{@"pid":_replyId,@"token":[DefaultManager getValueOfKey:@"token"],@"content":textView.text} sucBlock:^(id responseObject) {

                    [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                    if ([responseObject[@"status"] integerValue] == 1) {
                        UITextView *textView = [_commentView viewWithTag:11];
                        textView.text = nil;
                        _plachLabel.hidden = NO;
                        [self requestData];
                    }
                } failBlock:^{
                    
                }];
            }else{
                
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlComment parameters:@{@"pid":_pid,@"token":[DefaultManager getValueOfKey:@"token"],@"content":textView.text} sucBlock:^(id responseObject) {
                    [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                    if ([responseObject[@"status"] integerValue] == 1) {
                        UITextView *textView = [_commentView viewWithTag:11];
                        textView.text = nil;
                        _plachLabel.hidden = NO;
                        [self requestData];
                    }
                } failBlock:^{
                    
                }];
            }
            
        }
}

- (void)changeFavoNum{
    UIButton *btn = [self.view viewWithTag:10];
    NSString *urlStr;
    if (btn.selected) {
        btn.selected = NO;
        urlStr = KUrlFavDel;
    }else{
        btn.selected = YES;
        urlStr = KUrlFavAdd;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"token":[DefaultManager getValueOfKey:@"token"],@"id":_pid} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:urlStr parameters:str sucBlock:^(id responseObject) {
    } failBlock:^{
        
    }];
}

-(void)keyboardWillShow:(NSNotification*)notify
{
    //获取发消息的对象传递的数据
    NSDictionary *dict=notify.userInfo;
    //获取显示键盘的动画时间
    NSTimeInterval time=[[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //获取键盘的frame
    NSValue *keyboardFrame=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    //取出keyboardFrame对象中封装的结构体变量存入rect中
    [keyboardFrame getValue:&rect];
    //方法二：取出keyboardFrame对象中封装的结构体变量
    //rect=keyboardFrame.CGRectValue;
    [UIView animateWithDuration:time animations:^{
        CGRect frame=_commentView.frame;
        //将view向上移键盘的高度
        frame.origin.y-=rect.size.height;
        _commentView.frame=frame;
    }];

}

-(void)keyboardWillHide:(NSNotification*)notify
{
    //获取发消息的对象传递的数据
    NSDictionary *dict=notify.userInfo;
    //获取显示键盘的动画时间
    NSTimeInterval time=[[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:time animations:^{
        _commentView.frame=CGRectMake(0, KScreenHeight-50, KScreenWidth, 50);
    }];
    _isCommentSecond = NO;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITextView *textView = [_commentView viewWithTag:11];
    _isCommentSecond = NO;
    [textView resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide1 = @"detailCell";
    if (indexPath.section == 0) {
        
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ide1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"DetailCell" owner:self options:nil][0];
        }
        cell.model = _model;
        NSDictionary *dict = _detailDict[@"userinfo"];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:dict[@"headimg"]]];
        cell.headImgView.layer.cornerRadius = 20;
        cell.headImgView.layer.masksToBounds = YES;
        cell.nameLabel.text = dict[@"nickname"];
        return cell;
    }else if (indexPath.section == 1){

        RiderCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (!cell) {
            cell = [[RiderCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        }

        cell.model = _commentArr[indexPath.row];
            cell.delegate = self;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        NSInteger num = 4;
        if (_favoriteArr.count == 0) {
            return nil;
        }
        if (_favoriteArr.count < 4) {
            num = _favoriteArr.count;
        }
        
        UIButton *lastBtn = nil;
        for (int i = 0; i < _favoriteArr.count; i++) {
            UIButton *btn = [UIButton new];
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_favoriteArr[i][@"headimg"]]]];
            [btn setImage:image forState:UIControlStateNormal];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                if (lastBtn) {
                    make.left.equalTo(lastBtn.mas_right).offset(10);
                }else{
                    make.left.equalTo(view).offset(10);
                }
                make.height.width.mas_equalTo(30);
            }];
            lastBtn = btn;
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        [view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-10);
            make.height.width.mas_equalTo(20);
        }];
        
        UILabel *label = [MyControl labelWithTitle:[NSString stringWithFormat:@"%ld人赞过",[_favoriteArr count]] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(imageView.mas_left).offset(-5);
            make.height.mas_equalTo(20);
        }];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (_favoriteArr.count == 0) {
            return 0;
        }else{
            return 40;
        }
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JournalViewController *vc = [[JournalViewController alloc]init];
     vc.isOthers = YES;
    
    if (indexPath.section == 0) {
        vc.uid = _detailDict[@"uid"];
        vc.cateId = _detailDict[@"cate_id"];
    }else{
        vc.uid = [_commentArr[indexPath.row] uid];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    if (_isOthers) {
        KWS(ws);
        UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
        [MyControl UMSocialImageWithImage:image ws:ws];
    }else{
        [self showAlertViewWith:@[@"温馨提示",@"删除后将无法恢复",@"取消",@"确定"] sel:@selector(deleteTopic)];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        _isCommentSecond = NO;
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _plachLabel.hidden = NO;
    }else{
        _plachLabel.hidden = YES;
    }
}

#pragma mark CommentCellDelegate
- (void)deleteTopic{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id":_pid,@"token":[DefaultManager getValueOfKey:@"token"]} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:KUrlTopicDel parameters:str sucBlock:^(id responseObject) {
        
    } failBlock:^{
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)delCommentWithId:(NSString *)pid{
    _delComId = pid;
    [self showAlertViewWith:@[@"温馨提示",@"确定删除回帖吗",@"取消",@"确定"] sel:@selector(delCommentId)];
}

- (void)delCommentId{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id":_delComId,@"token":[DefaultManager getValueOfKey:@"token"]} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:KUrlCommentDel parameters:str sucBlock:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [self requestData];
        }else{
            [self showAlertViewWith:@[responseObject[@"msg"],@"确定",] sel:nil];
        }
    } failBlock:^{
        
    }];
}

- (void)replyWithModel:(CommentModel *)model{
    _replyId = model.pid;
    _isCommentSecond = YES;
    UITextView *textView = [_commentView viewWithTag:11];
    [textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
