//
//  VIPHostCardsTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPHostCardsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardKind;
@property (weak, nonatomic) IBOutlet UILabel *cardPrice;
@property (weak, nonatomic) IBOutlet UILabel *cardRemain;
@property (weak, nonatomic) IBOutlet UILabel *cardContaint;
@end
