//
//  pushView.h
//  animationOne
//
//  Created by 战明 on 16/5/15.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pushView : UIView


@property (nonatomic,copy)void (^btnClickBlock)(UIButton*sender);//


-(instancetype)initWithBtnFrame:(CGRect)frame;

-(void)pushButton;

@end
