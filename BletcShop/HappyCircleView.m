//
//  HappyCircleView.m
//  BletcShop
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "HappyCircleView.h"
#import "UIImage+GIF.h"
@implementation HappyCircleView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self initLoadingImageView];
    }
    return self;
}
- (void)initLoadingImageView
{
    NSString  *name = @"红色动效.gif";
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:name ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImageView *loadingImageView = [[UIImageView alloc]init];
    loadingImageView.backgroundColor = [UIColor clearColor];
    loadingImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    loadingImageView.frame = CGRectMake(SCREENWIDTH/2-30, (SCREENHEIGHT-64)/2-30, 60, 60);
    [self addSubview:loadingImageView];
}
@end
