//
//  MSGNotificationVC.m
//  BletcShop
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MSGNotificationVC.h"

@interface MSGNotificationVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MSGNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"消息提醒";
    LEFTBACK
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 54, SCREENWIDTH, 1)];
        line.backgroundColor=RGB(220, 220, 220);
        [cell addSubview:line];
    }
    cell.textLabel.text=@"您有一笔新消费!";
    cell.detailTextLabel.text=@"2017.9.21 09:20:35";
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
