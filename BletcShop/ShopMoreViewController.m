//
//  ShopMoreViewController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopMoreViewController.h"
#import "MoreViewCell.h"
#import "CreditThanViewController.h"
#import "FeedBackViewController.h"
#import "ShopUserInfoViewController.h"
#import "NewNextViewController.h"
//#import "AlertViewWithTableView.h"
#import "HotNewsVC.h"
@interface ShopMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    AlertViewWithTableView *view;
//}
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UITableView *setTable;

@end

@implementation ShopMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多";
//    view=[[AlertViewWithTableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) withArray:@[@"1.身份证号输入有误",@"2.店铺地址有误",@"3.营业执照图片不清晰",@"4.经营场地照片不清晰",@"5.水电票照片不清晰"]];
//    [self.view addSubview:view];
//    
//    [view.checkButton addTarget:self action:@selector(goRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [self _initTable];
    
}
//-(void)goRegisterVC{
//    [view removeFromSuperview];
//    NSLog(@"点击事件被触发了");
//}
-(NSArray *)data
{
    if (_data == nil) {
        _data = @[@[@"我的账户"],@[@"意见反馈",@"帮助中心"]];
    }
    return _data;
}
-(void)_initTable
{
    UITableView *setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    setTable.delegate = self;
    setTable.dataSource = self;
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTable.showsVerticalScrollIndicator = NO;
    setTable.bounces = NO;
    self.setTable = setTable;
    [self.view addSubview:setTable];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 4;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else
    return 4;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.data[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    MoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[MoreViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.data = self.data[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 && indexPath.row == 0){
        ShopUserInfoViewController *creditView = [[ShopUserInfoViewController alloc]init];
        [self.navigationController pushViewController:creditView animated:YES];
    }else if (indexPath.section == 1 ){
        if (indexPath.row==0) {
            FeedBackViewController *feedBackView = [[FeedBackViewController alloc]init];
            [self.navigationController pushViewController:feedBackView animated:YES];

        }else{

            HotNewsVC *VC = [[HotNewsVC alloc]init];
            VC.title = @"帮助中心";
            VC.href = @"http://www.cnconsum.com/cnconsum/helpCenter/merchant";
            [self presentViewController:VC animated:YES completion:nil];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if(buttonIndex ==0){
        
        
        [self exitApplication ];
        
    }
    
}

- (void)exitApplication
{
    
  
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.socketCutBy=1;
    [app cutOffSocket];
    UIWindow *window = app.window;
    
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
