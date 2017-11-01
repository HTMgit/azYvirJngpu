//
//  nmPlayOverallVC.m
//  nmLiveWatch
//
//  Created by zyh on 2017/10/30.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmPlayOverallVC.h"
#import "nmNoDataView.h"
#import "nmPlayRoomCell.h"
#import "nmWatchPlayVC.h"
#import "MJRefresh.h"

@interface nmPlayOverallVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,nmNoDataViewDelegate>{
    NSMutableArray<nmBaseModel> * arrPlayRooms;
    UICollectionView * playRoomCollectionView;
    
    MJRefreshNormalHeader *headerMJRefresh; //刷新；
    MJRefreshBackNormalFooter *footerMJRefresh;
    nmNoDataView * noDataView;
    int skip;
    BOOL isLoad;
}

@end

@implementation nmPlayOverallVC


-(id)init{
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPlayRooms =(NSMutableArray<nmBaseModel> *)[NSMutableArray arrayWithCapacity:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (!isLoad) {
        isLoad = 1;
        [self headerRefresh];
    }
}

-(void)getPlayOverallRoomList{
    if (!isLoad) {
        isLoad = 1;
        [self headerRefresh];
    }
}

-(void)getRoomListDataType:(int)type{
    NSString * requestUrl = [REQUESTURL stringByAppendingString:@"/live/list"];
    if (!type) {
        [SVProgressHUD showWithStatus:@""];
    }
    [ZYHCommonService createASIFormDataRequset:requestUrl param:nil completion:^(id result, NSError *error) {
        [SVProgressHUD dismiss];
        [headerMJRefresh endRefreshing];
        [footerMJRefresh endRefreshing];
        if (error) {
            [ZYHCommonService showMakeToastView:error.localizedDescription];
        }else{
            NSDictionary * dicResult =[NSDictionary dictionaryWithDictionary:result];
            if ([dicResult.allKeys containsObject:@"lives"]) {
                NSError * error;
                arrPlayRooms =(NSMutableArray<nmBaseModel> *)[nmPlayListRoomModel arrayOfModelsFromDictionaries:result[@"lives"] error:&error];
                if (arrPlayRooms.count) {
                    [self loadHaveRoomsView];
                }else{
                    [self loadNoRoomView];
                }
            }else{
                [self loadNoRoomView];
            }
        }
    }];
}


- (void)loadHaveRoomsView{
    if (noDataView) {
        noDataView.hidden = YES;
    }
    if(!playRoomCollectionView){
        [self loadRoomCollectionView];
    }
    playRoomCollectionView.hidden = NO;
    [playRoomCollectionView reloadData];
        
}

- (void)loadNoRoomView{
    if (!noDataView) {
        noDataView = [[nmNoDataView alloc]initWithFrame:CGRectMake(0, 0, kNMDeviceWidth, self.view.frame.size.height)];
        [noDataView setErrorStr:@"更多你喜欢的主播正在路上..."];
        noDataView.delegate =self;
        [noDataView setNoDataView];
        [self.view addSubview:noDataView];
    }
    if (playRoomCollectionView) {
        playRoomCollectionView.hidden = YES;
    }
    noDataView.hidden = NO;
}


-(void)loadRoomCollectionView{
    float w = (kNMDeviceWidth - 30) / 2;
    float h = w * 1.4;
    UICollectionViewFlowLayout *FlowLayout = [[UICollectionViewFlowLayout alloc] init];
    FlowLayout.itemSize = CGSizeMake(w, h);
    FlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    playRoomCollectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kNMDeviceWidth, kNMDeviceHeight - 64) collectionViewLayout:FlowLayout];
    [playRoomCollectionView registerClass:[nmPlayRoomCell class] forCellWithReuseIdentifier:@"GataWayCollectionCell"];
    playRoomCollectionView.dataSource = self;
    playRoomCollectionView.delegate = self;
    playRoomCollectionView.showsHorizontalScrollIndicator = NO;
    playRoomCollectionView.showsVerticalScrollIndicator = NO;
    playRoomCollectionView.alwaysBounceVertical = YES; //解决 当cell很少的情况下（没有占满屏幕），collectionView不能拖动的问题，
    playRoomCollectionView.bounces = NO;
    playRoomCollectionView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:playRoomCollectionView];
    
    
    //刷新
    footerMJRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    playRoomCollectionView.mj_footer= footerMJRefresh;
    headerMJRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    headerMJRefresh.automaticallyChangeAlpha = YES;
    headerMJRefresh.lastUpdatedTimeLabel.hidden = YES;
    playRoomCollectionView.mj_header = headerMJRefresh;
    
}

#pragma mark -collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrPlayRooms.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GataWayCollectionCell";
    nmPlayRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    nmPlayListRoomModel * roomModel = arrPlayRooms[indexPath.row];
    cell.labNum.text = [NSString stringWithFormat:@"%d",roomModel.userNum];
    [cell.imgShow sd_setImageWithURL:[NSURL URLWithString:roomModel.frontUrl] placeholderImage:[UIImage imageNamed:@"roomDef"]];
    cell.labBrief.text = roomModel.brief;
    NSURL * imgUrl =[NSURL URLWithString:roomModel.faceUrl];
    [cell.imgFace sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"userDef"]];//
    cell.labNickName.text = roomModel.nickname;
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 1;              //阴影透明度，默认0
    cell.layer.shadowOffset = CGSizeMake(2, 2); // shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    cell.layer.shadowRadius=2;//阴影半径，默认3
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    nmPlayListRoomModel * roomModel = arrPlayRooms[indexPath.row];
    nmWatchPlayVC * playVC = [[nmWatchPlayVC alloc]init];
    playVC.roomModel =roomModel;
    [playVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController hidesBottomBarWhenPushed];
    [self.parentViewController.navigationController pushViewController:playVC animated:NO];
}


#pragma mark -拉动刷新
- (void)footerRefresh {
    [self getRoomListDataType:1];
}

- (void)headerRefresh {
    skip = 1;
    [self getRoomListDataType:1];
}

-(void)noDataViewReloadData:(nmNoDataView *)view{
    [self getRoomListDataType:1];
}


@end
