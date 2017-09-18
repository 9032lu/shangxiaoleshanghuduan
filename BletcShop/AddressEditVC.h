//
//  AddressEditVC.h
//  BletcShop
//
//  Created by Bletc on 2017/9/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressEditVC : UIViewController

@property (nonatomic,copy)  void(^log_latBlock)(NSString *log,NSString*lat);// 经纬度

@end
