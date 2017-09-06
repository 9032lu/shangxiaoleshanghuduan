//
//  Data_statisticsVC.h
//  BletcShop
//
//  Created by Bletc on 2017/8/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Data_statisticsVC : UIViewController


@property (nonatomic,copy)NSString *date_string;// 日期

-(void)getdataWithDate:(NSString*)data_s;
@end
