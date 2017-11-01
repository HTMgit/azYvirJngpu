//
//  nmPlayRoomCell.h
//  nmLiveWatch
//
//  Created by zyh on 2017/10/31.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nmPlayRoomCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgShow;
@property (weak, nonatomic) IBOutlet UILabel *labBrief;
@property (weak, nonatomic) IBOutlet UIImageView *imgFace;
@property (weak, nonatomic) IBOutlet UILabel *labNickName;
@property (weak, nonatomic) IBOutlet UILabel *labNum;

@end
