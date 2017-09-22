//
//  LZDMemberCell.m
//  BletcShop
//
//  Created by Bletc on 2017/9/19.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "LZDMemberCell.h"


@implementation LZDMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.multipleSelectionBackgroundView = [UIView new];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.lineView.backgroundColor = RGB(240, 240, 240);

}




@end
