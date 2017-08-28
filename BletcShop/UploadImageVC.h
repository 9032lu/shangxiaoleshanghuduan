//
//  UploadImageVC.h
//  BletcShop
//
//  Created by Bletc on 2017/3/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadImageVC : UIViewController
@property (nonatomic , strong) NSDictionary *infoDic;// <#Description#>

@property (nonatomic,copy)void (^reloadData)();// 刷新数据

@end
