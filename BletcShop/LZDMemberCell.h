//
//  LZDMemberCell.h
//  BletcShop
//
//  Created by Bletc on 2017/9/19.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *datetime;

@property (weak, nonatomic) IBOutlet UILabel *cardTypelab;
@property (weak, nonatomic) IBOutlet UILabel *consumeLab;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@end
