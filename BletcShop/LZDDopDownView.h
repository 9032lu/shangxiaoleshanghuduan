//
//  LZDDopDownView.h
//  BletcShop
//
//  Created by Bletc on 2017/9/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDDopDownView : UIView

@property(nonatomic,strong)NSArray *data_source_A;//数据源


@property (nonatomic,copy)void (^selectBlock)(NSInteger section,NSInteger row);// <#Description#>


- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height andSuperView:(UIView*)supview;

- (void)selectDefalutIndexPath;



@end



@interface LZDdopCell : UITableViewCell

@property (nonatomic , weak) UILabel *titleLab;
@property (nonatomic , weak) UIView *cellBackView;// 


+(instancetype)creatLZDDopCellWithTableView:(UITableView*)tableView;


@end
