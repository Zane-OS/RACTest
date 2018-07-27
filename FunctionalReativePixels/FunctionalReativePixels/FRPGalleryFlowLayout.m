//
//  FRPGalleryFlowLayout.m
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    } else {
        self.itemSize = CGSizeMake(145, 145);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

@end
