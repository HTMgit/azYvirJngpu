//
//  nmLiveWatchTabbar.m
//  nmLiveWatch
//
//  Created by zyh on 2017/10/30.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmLiveWatchTabbar.h"

#import "nmMainPageVC.h"
#import "nmUserVC.h"
#import "SCSelfInformationVC.h"

@interface nmLiveWatchTabbar (){
    nmMainPageVC * mainVC;
//    nmUserVC * userVC;
    SCSelfInformationVC * userVC;
}
@end

@implementation nmLiveWatchTabbar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    
    mainVC =[[nmMainPageVC alloc]init];
    UINavigationController * mainNav =[[UINavigationController alloc]initWithRootViewController:mainVC];
    mainNav.navigationBar.translucent = NO;
    mainNav.tabBarItem.title=@"首页";
    mainNav.tabBarItem.image=[UIImage imageNamed:@"main_def"];
//    mainNav.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"main_def"] selectedImage:[UIImage imageNamed:@"main_sel"]];
//
//
    userVC =[[SCSelfInformationVC alloc]init];
    UINavigationController * userNav =[[UINavigationController alloc]initWithRootViewController:userVC];
    userNav.navigationBar.translucent = NO;
    
    userNav.tabBarItem.title=@"我";
    userNav.tabBarItem.image=[UIImage imageNamed:@"mySelf_def"];
//    userNav.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"mySelf_def"] selectedImage:[UIImage imageNamed:@"mySelf_sel"]];
//

    
//    NSArray * images=@[@"main_def",@"mySelf_def",@"tb_device",@"tb_experience"];
//     NSArray * selectImages=@[@"main_sel",@"mySelf_sel",@"tb_device_sel",@"tb_experience_sel"];
//     NSArray * titleArr=@[@"首页",@"我",@"设备",@"体验"];
//    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj setTitle:titleArr[idx]];
//        [obj setImage:[UIImage imageNamed:images[idx]]];
//        [obj setSelectedImage:[UIImage imageNamed:selectImages[idx]]];
//    }];
    
    self.tabBar.tintColor=[UIColor orangeColor];
    [self setViewControllers:@[mainNav,userNav] animated:NO];
    self.tabBarController.tabBar.translucent = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
