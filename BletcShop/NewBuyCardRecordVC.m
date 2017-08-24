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
    DOPDropDownMenu *_menu;;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *date_A;
@end

@implementation NewBuyCardRecordVC
-(NSArray *)date_A{
    if (!_date_A) {
        NSArray *year_A = @[@"2016",@"2017"];
        NSArray *month_A = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        NSArray *dayArray=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
        
        _date_A = @[year_A,month_A,dayArray];
    }
    return _date_A;
}
-(void)chat{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"办卡明细";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"统计表" style:UIBarButtonItemStylePlain target:self action:@selector(chat)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    _menu = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:40 andSuperView:self.view];
    
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
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
    
    NSLog(@"------%ld",indexPath.row);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
