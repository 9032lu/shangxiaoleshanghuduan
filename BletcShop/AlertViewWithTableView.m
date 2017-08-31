//
//  AlertViewWithTableView.m
//  BletcShop
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AlertViewWithTableView.h"

@implementation AlertViewWithTableView
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.3];
        
        [self setUi:array];
        
    }
    return self;
}
-(void)setUi:(NSArray *)array{
    UIView *whiteView=[[UIView alloc]init ];
    CGFloat height=0;
    if (array.count<=4) {
        NSLog(@"%ld",self.reasonArr.count);
        height=70+56+45*array.count;
    }else{
        height=70+56+45*4;
        
    }
    whiteView.frame=CGRectMake(50, 170, self.width-100, height);
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.layer.cornerRadius=12;
    whiteView.clipsToBounds=YES;
    [self addSubview:whiteView];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, whiteView.width, 16)];
    titleLable.text=@"审核失败";
    titleLable.font=[UIFont systemFontOfSize:16.0f];
    titleLable.textAlignment=NSTextAlignmentCenter;
    [whiteView addSubview:titleLable];
    
    UILabel *failReason=[[UILabel alloc]initWithFrame:CGRectMake(0, titleLable.bottom+10, whiteView.width, 13)];
    failReason.text=[NSString stringWithFormat:@"失败原因:%ld项",array.count];
    failReason.font=[UIFont systemFontOfSize:13];
    failReason.textAlignment=NSTextAlignmentCenter;
    [whiteView addSubview:failReason];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, failReason.bottom+10, whiteView.width, 1)];
    line.backgroundColor=RGB(220, 220, 220);
    [whiteView addSubview:line];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, line.bottom, whiteView.width, height-70-56)];
    tableView.rowHeight=45;
    tableView.delegate=self;
    tableView.dataSource=self;
    [whiteView addSubview:tableView];
    self.mytableview=tableView;
    self.reasonArr=array;
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, tableView.bottom-1, whiteView.width, 1)];
    line2.backgroundColor=RGB(220, 220, 220);
    [whiteView addSubview:line2];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:RGB(32,159,248) forState:UIControlStateNormal];
    button.frame=CGRectMake(0, line2.bottom, whiteView.width, 55);
    [button setTitle:@"查看并重新申请" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [whiteView addSubview:button];
    self.checkButton = button;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reasonArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor=RGB(51, 51, 51);
    cell.textLabel.text=self.reasonArr[indexPath.row];
    return cell;
}
-(void)viewDidLayoutSubviews {
    
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
