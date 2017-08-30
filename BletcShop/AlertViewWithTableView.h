//
//  AlertViewWithTableView.h
//  BletcShop
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewWithTableView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *reasonArr;
@property(nonatomic,strong)UITableView *mytableview;
@property(nonatomic,strong)UIButton *checkButton;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array;
@end
