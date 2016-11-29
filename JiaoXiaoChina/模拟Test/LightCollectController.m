//
//  LightCollectController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "LightCollectController.h"
#import "LightCell.h"
#import <AVFoundation/AVFoundation.h>
#define KTitle @"title"
#define KImage @"image"
#define KSelImage @"selImage"
#define KSelect @"select"
#define KPath @"path"
@interface LightCollectController ()<UICollectionViewDelegateFlowLayout,AVAudioPlayerDelegate>
{
    AVAudioPlayer *_avAudioPlayer;
    NSMutableArray *_dataArray;
    NSInteger _currentIndex;
    NSInteger _lastIndex;
    LightCell *_lastCell;
}
@end

@implementation LightCollectController

static NSString * const reuseIdentifier = @"myCell";

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout flag:(NSInteger)flag{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _dataArray = [[NSMutableArray alloc]init];
        [self requestDataWithFlag:flag];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.collectionView.collectionViewLayout = flow;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LightCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)requestDataWithFlag:(NSInteger)flag{
    if (flag == 0) {
        for (int i = 0; i < 8; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:@"subject3_list_icon_light" forKey:KImage];
            [dict setObject:[NSString stringWithFormat:@"灯光%d",i+1] forKey:KTitle];
            [dict setObject:@"subject3_icon_voice" forKey:KSelImage];
            [dict setObject:[NSNumber numberWithBool:0] forKey:KSelect];
            [dict setObject:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"l%d",i] ofType:@"mp3" ] forKey:KPath];
            [_dataArray addObject:dict];
        }
    }else if (flag == 1){
        NSArray *titles = @[@"考试准备",@"起步",@"路口直行",@"变更车道",@"公共汽车站",@"学校",@"直线行驶",@"左转",@"右转",@"加减档",@"会车",@"超车",@"减速",@"限速",@"人行横道",@"人行横道有行人",@"隧道",@"掉头",@"靠边停车"];
        for (int i = 0; i < titles.count; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSString stringWithFormat:@"v%d",i] forKey:KImage];
            [dict setObject:titles[i] forKey:KTitle];
            [dict setObject:@"subject3_icon_voice" forKey:KSelImage];
            [dict setObject:[NSNumber numberWithBool:0] forKey:KSelect];
            [dict setObject:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"mp3" ] forKey:KPath];
            [_dataArray addObject:dict];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.itemLabel.text = dict[KTitle];
    cell.itemImageView.image = [UIImage imageNamed:dict[KImage]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_lastIndex >= 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dataArray[_lastIndex]];
        NSString *imageName;
        if ([dict[KSelect] boolValue]) {
            [dict setObject:[NSNumber numberWithBool:0] forKey:KSelect];
            imageName = dict[KImage];
            [_avAudioPlayer stop];
            _avAudioPlayer = nil;
            _lastCell.itemImageView.image = [UIImage imageNamed:imageName];
        }
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
    LightCell *cell = (LightCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *imageName;
    if ([dict[KSelect] boolValue]) {
        [dict setObject:[NSNumber numberWithBool:0] forKey:KSelect];
        imageName = dict[KImage];
        [_avAudioPlayer stop];
        _avAudioPlayer = nil;
    }else{
        [dict setObject:[NSNumber numberWithBool:1] forKey:KSelect];
        imageName = dict[KSelImage];
        [self playVidioWithPath:dict[KPath]];
    }
    cell.itemImageView.image = [UIImage imageNamed:imageName];
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
    _lastIndex = indexPath.row;
    _lastCell = cell;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(void)playVidioWithPath:(NSString *)path{
    
    if (path.length==0||[path hasPrefix:@"http://"]||[path rangeOfString:@"https://"].location!=NSNotFound) {
        return;
    }
    //根据本地路径创建url
    NSURL *url=[NSURL fileURLWithPath:path];
    if (_avAudioPlayer==nil) {
        //根据本地url来创建AVAudioPlayer的对象
        _avAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    }
    //设置代理
    _avAudioPlayer.delegate=self;
    //对音频预处理，准备播放
    [_avAudioPlayer prepareToPlay];
    //播放音频
    [_avAudioPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSMutableDictionary *dict = _dataArray[_currentIndex];
    [dict setObject:[NSNumber numberWithBool:0] forKey:KSelect];
    NSString  *imageName = dict[KImage];
    NSIndexPath *index = [NSIndexPath indexPathWithIndex:_currentIndex];
    LightCell *cell = (LightCell *)[self.collectionView cellForItemAtIndexPath:index];
    cell.itemImageView.image = [UIImage imageNamed:imageName];
    [self.collectionView reloadData];
    _avAudioPlayer = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    NSMutableDictionary *dict = _dataArray[_currentIndex];
    [dict setObject:[NSNumber numberWithBool:0] forKey:KSelect];
    NSString  *imageName = dict[KImage];
    NSIndexPath *index = [NSIndexPath indexPathWithIndex:_currentIndex];
    LightCell *cell = (LightCell *)[self.collectionView cellForItemAtIndexPath:index];
    cell.itemImageView.image = [UIImage imageNamed:imageName];
    [self.collectionView reloadData];
    _avAudioPlayer = nil;
    _lastCell = nil;
    _lastIndex = -1;
}
@end
