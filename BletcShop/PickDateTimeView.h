//
//  PickDateTimeView.h
//  BletcShop
//
//  Created by Bletc on 2017/8/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickDateTimeView : UIView
@property (nonatomic,copy)void (^sureBtnClick)(NSString *value);
@property (nonatomic, strong) NSArray * dataSource;

-(void)show;
@end
