//
//  ChooseTradeVC.h
//  BletcShop
//
//  Created by apple on 2017/8/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseTradeVCBlock)(NSString *string);
@interface ChooseTradeVC : UIViewController
@property (nonatomic,copy)ChooseTradeVCBlock resultBlock;//
@end
