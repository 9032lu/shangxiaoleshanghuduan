//
//  PickReasonView.h
//  BletcShop
//
//  Created by Bletc on 2017/8/29.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickReasonView : UIView
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic,copy)void (^sureBtnClick)(NSArray *value_A);
@property (nonatomic,copy)NSString *title;// <#Description#>


@property BOOL mutab_select;//是否可多选多选,默认NO
- (void)show;
@end
