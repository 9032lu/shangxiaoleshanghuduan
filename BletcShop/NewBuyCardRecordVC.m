//
//  NewBuyCardRecordVC.m
//  BletcShop
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewBuyCardRecordVC.h"
#import "NewBuyCardRecordsTableViewCell.h"
#import "DOPDropDownMenu.h"
@interface NewBuyCardRecordVC ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    DOPDropDownMenu *_menu;
    
    NSString *year_s;
    NSString *month_s;
    NSString *day_s;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *date_A;
@end

@implementation NewBuyCardRecordVC
-(NSArray *)date_A{
    if (!_date_A) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSString *now_year =  [formatter stringFromDate:date];
        
        year_s = now_year;
        NSMutableArray *year_A = [NSMutableArray array];
        
        for (int i = [now_year intValue]; i >= 2016; i --) {
            
            [year_A addObject:[NSString stringWithFormat:@"%d年",i]];
        }
        
        
        NSArray *month_A = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        
        
        NSMutableArray *dayArray = [NSMutableArray array];
        NSDateFormatter *month_format = [[NSDateFormatter alloc]init];
        [month_format setDateFormat:@"MM"];
        NSString *now_month = [month_format stringFromDate:date];
        
        month_s = now_month;
        
       NSInteger days = [self howManyDaysInThisYear:[now_year integerValue] withMonth:[now_month integerValue]];
        
        for (int i =1; i <=days; i++) {
            [dayArray addObject:[NSString stringWithFormat:@"%d日",i]];

        }
        
        
        _date_A = @[year_A,month_A,dayArray];
    }
    return _date_A;
}
-(void)chat{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);

    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"统计表" style:UIBarButtonItemStylePlain target:self action:@selector(chat)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    _menu = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:40 andSuperView:self.view];
    
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *month_format = [[NSDateFormatter alloc]init];
    [month_format setDateFormat:@"MM"];
    NSString *now_month = [month_format stringFromDate:date];
    
    NSDateFormatter *day_format = [[NSDateFormatter alloc]init];
    [day_format setDateFormat:@"dd"];
    NSString *now_day = [day_format stringFromDate:date];

    day_s = now_day;
    
    DOPIndexPath *indexPath = [DOPIndexPath indexPathWithCol:1 row:[now_month intValue]-1];
    DOPIndexPath *indexPath1 = [DOPIndexPath indexPathWithCol:2 row:[now_day intValue]-1];

    [_menu selectIndexPath:indexPath];
    [_menu selectIndexPath:indexPath1];
    
    
    UILabel *totalMoney=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 66)];
    totalMoney.text=@"办卡总金额：10′000元";
    totalMoney.textAlignment=NSTextAlignmentCenter;
    totalMoney.font=[UIFont systemFontOfSize:16];
    totalMoney.backgroundColor=RGB(240, 240, 240);
    totalMoney.textColor=RGB(51, 51, 51);
    [self.view addSubview:totalMoney];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 106, SCREENWIDTH, SCREENHEIGHT-64-106) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewBuyCardRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewBuyCardRecordsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewBuyCardRecordsTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    label.text=@"详情";
    label.textColor=RGB(51, 51, 51);
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, SCREENWIDTH, 1)];
    line.backgroundColor=RGB(220, 220, 220);
    [view addSubview:line];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark ---DOPDropDownMenu---DELEGATE
-(NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    

    
    return self.date_A[indexPath.column][indexPath.row];
}

-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    return [self.date_A[column] count];
}
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return self.date_A.count;
}
-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.column ==0) {
        year_s = [menu titleForRowAtIndexPath:indexPath];
    }
    if (indexPath.column ==1) {
        month_s = [menu titleForRowAtIndexPath:indexPath];
        
    }
    if (indexPath.column ==3) {
        day_s = [menu titleForRowAtIndexPath:indexPath];
        
    }
    if (indexPath.column ==0 || indexPath.column ==1) {
        NSInteger days = [self howManyDaysInThisYear:[year_s integerValue] withMonth:[month_s integerValue]];
        
        NSMutableArray *d_a = [NSMutableArray arrayWithArray:self.date_A];
        
        NSMutableArray *dayArray = d_a[2];
        [dayArray removeAllObjects];
        for (int i =1; i <=days; i++) {
            [dayArray addObject:[NSString stringWithFormat:@"%d日",i]];
            
        }
        [d_a replaceObjectAtIndex:2 withObject:dayArray];
        
        _date_A = d_a;

        DOPIndexPath *indexPath1 = [DOPIndexPath indexPathWithCol:2 row:0];
        
        [_menu selectIndexPath:indexPath1];

    }
    
    
    
    NSLog(@"------%@",[menu titleForRowAtIndexPath:indexPath]);
}




- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
   
    if (month ==1 || month ==3 ||month ==5 ||month ==7 ||month ==8 ||month == 10|| month ==12) {
        return 31;
    }
    
    
    if (month ==4 || month ==6 || month ==9 || month ==11) {
        return 30;
    }
    
    
    if (year%4==1 ||year %4 ==2|| year%4 ==3) {
        return 28;
    }
    
    if (year%400 ==0) {
        return 29;
    }
    if (year %100 ==0) {
        return 28;
    }
    
    
    return 29;
}

@end
