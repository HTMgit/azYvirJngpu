//
//  nmMainPageVC.m
//  nmLiveWatch
//
//  Created by zyh on 2017/10/30.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmMainPageVC.h"
#import "nmPlayOverallVC.h"

//#import "ZYHSliderBtnView.h"
#import "SUNSlideSwitchView.h"
@interface nmMainPageVC ()<UIScrollViewDelegate, SUNSlideSwitchViewDelegate>{
    NSMutableArray * arrPlayings;
    UIScrollView * liveScrollView;
    UIButton * btnAdv;
    SUNSlideSwitchView * titleSlider;
    nmPlayOverallVC * playVC1;
    nmPlayOverallVC * playVC2;
    nmPlayOverallVC * playVC3;
    
    float proportionNum;
    int MAINCATEGORYWHIGHT;
    int currentSel;
    int haveLoad;
}

@end

@implementation nmMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"檬檬直播";
    MAINCATEGORYWHIGHT = 40;
    proportionNum = 0.4;
    [self drawAdvButton];
    [self drawMainScrollView];
    [self drawSubCategoryList];
}


//界面
-(void)drawAdvButton{
    btnAdv =[[UIButton alloc]init];
    [self.view addSubview:btnAdv];
    [btnAdv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(MAINCATEGORYWHIGHT);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kNMDeviceWidth * proportionNum);
    }];
}

- (void)drawSubCategoryList {
    if (titleSlider) {
        [titleSlider removeFromSuperview];
    }
    
    titleSlider = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, kNMDeviceWidth, 44)];
    [self.view addSubview:titleSlider];
//    [titleSlider.titleArray removeAllObjects];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"综合", @"原石", @"翡翠", nil];
    
    titleSlider.tabItemNormalColor = fRgbColor(128, 128, 128);
    titleSlider.tabItemSelectedColor = [UIColor orangeColor];
    titleSlider.shadowImage = [UIImage imageNamed:@"sliderShadowImg"];
    titleSlider.slideSwitchViewDelegate = self;
    titleSlider.titleArray = [NSMutableArray arrayWithArray:arr];
    [titleSlider buildUI];
    
    CGFloat cellscreenWidth = (kNMDeviceWidth - MAINCATEGORYWHIGHT) / 2;
    CGFloat cellscreenHight = cellscreenWidth * 1.49;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(cellscreenWidth, cellscreenHight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self.view addSubview:titleSlider];
}

-(void)drawMainScrollView{
    
    float ScrollHeight =kNMDeviceHeight-(44+(kNMDeviceWidth * proportionNum+64+49));
    liveScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+(kNMDeviceWidth * proportionNum), kNMDeviceWidth, ScrollHeight)];
    liveScrollView.backgroundColor = [UIColor clearColor];
    liveScrollView.bounces = NO;
    liveScrollView.showsHorizontalScrollIndicator = NO;
    liveScrollView.pagingEnabled = YES;
    liveScrollView.scrollEnabled = NO;
    liveScrollView.delegate = self;
    liveScrollView.contentSize = CGSizeMake(3 * kNMDeviceWidth, ScrollHeight);
    [self.view addSubview:liveScrollView];
//    [liveScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    playVC1 =[[nmPlayOverallVC alloc]init];
    playVC2 =[[nmPlayOverallVC alloc]init];
    playVC3 =[[nmPlayOverallVC alloc]init];
    [self addChildViewController:playVC1];
    [self addChildViewController:playVC2];
    [self addChildViewController:playVC3];
    [liveScrollView addSubview:playVC1.view];
    [liveScrollView addSubview:playVC2.view];
    [liveScrollView addSubview:playVC3.view];
    playVC1.view.frame = CGRectMake(0, 0, kNMDeviceWidth, ScrollHeight);
    playVC2.view.frame = CGRectMake(kNMDeviceWidth, 0, kNMDeviceWidth, ScrollHeight);
    playVC3.view.frame = CGRectMake(2*kNMDeviceWidth, 0, kNMDeviceWidth, ScrollHeight);
  
}

//数据



//执行
#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view {
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    return self;
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number {
    CGPoint point = CGPointMake(number*kNMDeviceWidth, 0);
    currentSel=(int)number;
    [liveScrollView setContentOffset:point animated:YES];
    if (!(haveLoad&1)&&number==0) {
        [playVC1 getPlayOverallRoomList];
    }else if (!(haveLoad&2)&&number==1) {
        [playVC2 getPlayOverallRoomList];
    }else if (!(haveLoad&4)&&number==2) {
        [playVC3 getPlayOverallRoomList];
    }
}



- (void)dealloc {
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
