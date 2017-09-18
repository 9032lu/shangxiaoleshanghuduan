//
//  ShopAppriseMoneyGetVC.h
//  BletcShop
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetMoneyVCBlock)();
@interface ShopAppriseMoneyGetVC : UIViewController
@property (nonatomic,copy)NSString *sum_string;//可提取余额
@property (nonatomic,copy)NSString *acount;//卡号
@property (nonatomic,copy)GetMoneyVCBlock block;//
@end
