//
//  CardBuyRecTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardBuyRecTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *costMoney;

@end
