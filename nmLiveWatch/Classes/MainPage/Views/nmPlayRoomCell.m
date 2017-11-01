//
//  nmPlayRoomCell.m
//  nmLiveWatch
//
//  Created by zyh on 2017/10/31.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmPlayRoomCell.h"

@implementation nmPlayRoomCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews =
        [[NSBundle mainBundle] loadNibNamed:@"nmPlayRoomCell"
                                      owner:self
                                    options:nil];
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0]
              isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1;              //阴影透明度，默认0
        self.layer.shadowOffset = CGSizeMake(2, 2); // shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowRadius=2;//阴影半径，默认3
        
    }
    return self;
}

@end
