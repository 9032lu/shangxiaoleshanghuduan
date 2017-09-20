//
//  VIPInfoVCS.m
//  BletcShop
//
//  Created by apple on 2017/9/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "VIPInfoVCS.h"
#import "VIPInfoTableViewCell.h"

@interface VIPInfoVCS ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableFootVeiw;

@end

@implementation VIPInfoVCS
- (IBAction)sendMSG:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"会员信息";
    LEFTBACK
    self.tableView.tableHeaderView=_tableHeadView;
    self.tableView.tableFooterView=_tableFootVeiw;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VIPInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VIPInfoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VIPInfoTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row==0) {
        cell.title.text=@"消费总额(元)：";
        cell.money.text=@"2000";
    }else{
        cell.title.text=@"充值总额(次)：";
        cell.money.text=@"3000";
    }
    return cell;
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
