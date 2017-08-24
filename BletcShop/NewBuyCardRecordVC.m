//
//  NewBuyCardRecordVC.m
//  BletcShop
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewBuyCardRecordVC.h"
#import "NewBuyCardRecordsTableViewCell.h"
//#import "DOPDropDownMenu.h"
@interface NewBuyCardRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation NewBuyCardRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
