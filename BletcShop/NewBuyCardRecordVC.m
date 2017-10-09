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
#import "UIImageView+WebCache.h"
#import "ChatForAllDatasVC.h"
@interface NewBuyCardRecordVC ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    DOPDropDownMenu *_menu;
    
    NSString *year_s;
    NSString *month_s;
    NSString *day_s;
    SDRefreshHeaderView *_refreshheader;
    SDRefreshFooterView *_refreshFooter;
    UILabel *totalMoney;
   
    
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *date_A;
@property(nonatomic,copy) NSString *date_string;;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataSourse_A;

@end

@implementation NewBuyCardRecordVC
-(NSMutableArray *)dataSourse_A{
    if (!_dataSourse_A) {
        _dataSourse_A = [NSMutableArray array];
    }
    return _dataSourse_A;
}

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
        
        
        NSArray *month_A = @[@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月"];
        
        
        NSMutableArray *dayArray = [NSMutableArray array];
        NSDateFormatter *month_format = [[NSDateFormatter alloc]init];
        [month_format setDateFormat:@"MM"];
        NSString *now_month = [month_format stringFromDate:date];
        
       NSInteger days = [self howManyDaysInThisYear:[now_year integerValue] withMonth:[now_month integerValue]];
        
        for (int i =1; i <=days; i++) {
            if (i<10) {
                [dayArray addObject:[NSString stringWithFormat:@"0%d日",i]];

            }else{
                [dayArray addObject:[NSString stringWithFormat:@"%d日",i]];

            }

        }
        [dayArray insertObject:@"全月" atIndex:0];
        
        
        _date_A = @[year_A,month_A,dayArray];
    }
    return _date_A;
}
-(void)chat{
    AppDelegate *dele=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"====%@",dele.shopInfoDic[@"muid"]);
    ChatForAllDatasVC *chatForAllDatasVC=[[ChatForAllDatasVC alloc]init];
    if ([self.navigationItem.title containsString:@"办卡"]){
         chatForAllDatasVC.url=[NSString stringWithFormat:@"http://www.cnconsum.com/cnconsum/App/Extra/chart/getCardBuyChart?muid=%@&date=%@",dele.shopInfoDic[@"muid"],self.date_string];
    }else if ([self.navigationItem.title containsString:@"续卡"]){
         chatForAllDatasVC.url=[NSString stringWithFormat:@"http://www.cnconsum.com/cnconsum/App/Extra/chart/getCardRenewChart?muid=%@&date=%@",dele.shopInfoDic[@"muid"],self.date_string];
    }else if ([self.navigationItem.title containsString:@"升级"]){
         chatForAllDatasVC.url=[NSString stringWithFormat:@"http://www.cnconsum.com/cnconsum/App/Extra/chart/getCardUpgradeChart?muid=%@&date=%@",dele.shopInfoDic[@"muid"],self.date_string];
    }else if ([self.navigationItem.title containsString:@"消费"]){
         chatForAllDatasVC.url=[NSString stringWithFormat:@"http://www.cnconsum.com/cnconsum/App/Extra/chart/getConsumChart?muid=%@&date=%@",dele.shopInfoDic[@"muid"],self.date_string];
    }else if ([self.navigationItem.title containsString:@"现金支付"]){
         chatForAllDatasVC.url=[NSString stringWithFormat:@"http://www.cnconsum.com/cnconsum/App/Extra/chart/getTallyChart?muid=%@&date=%@",dele.shopInfoDic[@"muid"],self.date_string];
    }
   
    [self.navigationController pushViewController:chatForAllDatasVC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.index = 1;
    
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

    
    DOPIndexPath *indexPath = [DOPIndexPath indexPathWithCol:1 row:[now_month intValue]-1];
    DOPIndexPath *indexPath1 = [DOPIndexPath indexPathWithCol:2 row:[now_day intValue]];

    [_menu selectIndexPath:indexPath];
    [_menu selectIndexPath:indexPath1];
    
    
   totalMoney=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 66)];
    totalMoney.text=@"办卡总金额：0元";
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
    
    
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:_tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.index=1;
        //请求数据
        [tempSelf getdataWithDate:tempSelf.date_string];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:_tableView];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.index++;
        //数据请求
        [tempSelf getdataWithDate:tempSelf.date_string];
        
    };

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourse_A.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewBuyCardRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewBuyCardRecordsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewBuyCardRecordsTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataSourse_A.count!=0) {
        NSDictionary *dic = _dataSourse_A[indexPath.row];
       
        [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        
        
        cell.orderCode.text =@"";

        
        if ([self.navigationItem.title containsString:@"办卡"]) {
            
        
        
        cell.userName.text =[NSString stringWithFormat:@"姓名：%@",[NSString getTheNoNullStr:dic[@"name"] andRepalceStr:@"-"]] ;
            
         if (!dic[@"name"]) {
                cell.userName.text =[NSString stringWithFormat:@"昵称：%@",[NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@"-"]] ;

            }
        
        cell.orderTime.text =[NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@"-"] ;
        
        cell.cardType.text = [NSString stringWithFormat:@"办卡类型：%@", [NSString getTheNoNullStr:dic[@"card_type"] andRepalceStr:@"-"]];
        cell.orderMoney.text = [NSString stringWithFormat:@"办卡金额：%@",[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"-"] stringByAppendingString:@"元"]];
        }
        
        
        if ([self.navigationItem.title containsString:@"续卡"]) {
            
            
            
            cell.userName.text =[NSString stringWithFormat:@"姓名：%@",[NSString getTheNoNullStr:dic[@"name"] andRepalceStr:@"-"]] ;
            
            if (!dic[@"name"]) {
                cell.userName.text =[NSString stringWithFormat:@"昵称：%@",[NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@"-"]] ;
                
            }
            
            cell.orderTime.text =[NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@"-"] ;
            
            cell.cardType.text = [NSString stringWithFormat:@"续卡类型：%@", [NSString getTheNoNullStr:dic[@"card_type"] andRepalceStr:@"-"]];
            cell.orderMoney.text = [NSString stringWithFormat:@"续卡金额：%@",[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"-"] stringByAppendingString:@"元"]];
        }
        
        
        
        if ([self.navigationItem.title containsString:@"升级"]) {
            
            
            
            cell.userName.text =[NSString stringWithFormat:@"姓名：%@",[NSString getTheNoNullStr:dic[@"name"] andRepalceStr:@"-"]] ;
            
            if (!dic[@"name"]) {
                cell.userName.text =[NSString stringWithFormat:@"昵称：%@",[NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@"-"]] ;
                
            }
            
            cell.orderTime.text =[NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@"-"] ;
            
            cell.cardType.text = [NSString stringWithFormat:@"升级类型：%@", [NSString getTheNoNullStr:dic[@"card_type"] andRepalceStr:@"-"]];
            cell.orderMoney.text = [NSString stringWithFormat:@"升级金额：%@",[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"-"] stringByAppendingString:@"元"]];
        }
        

        
        if ([self.navigationItem.title containsString:@"消费"]) {
            
            
            
            cell.userName.text =[NSString stringWithFormat:@"姓名：%@",[NSString getTheNoNullStr:dic[@"name"] andRepalceStr:@"-"]] ;
            
            if (!dic[@"name"]) {
                cell.userName.text =[NSString stringWithFormat:@"昵称：%@",[NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@"-"]] ;
                
            }
            
            cell.orderTime.text =[NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@"-"];
            
            cell.cardType.text = @"";
            cell.orderMoney.text = [NSString stringWithFormat:@"消费金额：%@",[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"-"] stringByAppendingString:@"元"]];
        }
        

        
        if ([self.navigationItem.title containsString:@"现金支付"]) {
            
            
            
            cell.userName.text =[NSString stringWithFormat:@"名称：%@",[NSString getTheNoNullStr:dic[@"name"] andRepalceStr:@"-"]] ;
            
            if (!dic[@"name"]) {
                cell.userName.text =[NSString stringWithFormat:@"昵称：%@",[NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@"-"]] ;
                
            }
            
            cell.orderTime.text =[NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@"-"] ;
            
            cell.cardType.text = @"";
            cell.orderMoney.text = [NSString stringWithFormat:@"消费金额：%@",[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"-"] stringByAppendingString:@"元"]];
        }
        

        
               

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
        year_s = [[menu titleForRowAtIndexPath:indexPath] stringByReplacingOccurrencesOfString:@"年" withString:@""];
    }
    if (indexPath.column ==1) {
        month_s = [[menu titleForRowAtIndexPath:indexPath] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        
    }
    if (indexPath.column ==2) {
        day_s = [[menu titleForRowAtIndexPath:indexPath] stringByReplacingOccurrencesOfString:@"日" withString:@""];
        
        
        
    }
    if (indexPath.column ==0 || indexPath.column ==1) {
        NSInteger days = [self howManyDaysInThisYear:[year_s integerValue] withMonth:[month_s integerValue]];
        
        NSMutableArray *d_a = [NSMutableArray arrayWithArray:self.date_A];
        
        NSMutableArray *dayArray = d_a[2];
        [dayArray removeAllObjects];
        for (int i =1; i <=days; i++) {
            if (i<10) {
                [dayArray addObject:[NSString stringWithFormat:@"0%d日",i]];
                
            }else{
                [dayArray addObject:[NSString stringWithFormat:@"%d日",i]];
                
            }
            
        }
        [dayArray insertObject:@"全月" atIndex:0];

        [d_a replaceObjectAtIndex:2 withObject:dayArray];
        
        _date_A = d_a;

        
        if ([[day_s stringByReplacingOccurrencesOfString:@"日" withString:@""] integerValue]> days) {
            DOPIndexPath *indexPath1 = [DOPIndexPath indexPathWithCol:2 row:0];
            
            [_menu selectIndexPath:indexPath1];

        }
        
      
    }
    
    
    if (year_s.length !=0 && month_s.length !=0 &&day_s.length !=0) {
        
        self.date_string = (![day_s isEqualToString:@"全月"] &&  day_s.length !=0) ? [NSString stringWithFormat:@"%@-%@-%@",year_s,month_s,day_s] : [NSString stringWithFormat:@"%@-%@",year_s,month_s];

        
        
        
        [self getdataWithDate:self.date_string];
    }

    
    
    NSLog(@"------%@",[menu titleForRowAtIndexPath:indexPath]);
}



-(void)getdataWithDate:(NSString*)date{
    
    NSString *url;
    if ([self.navigationItem.title containsString:@"办卡"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getCardBuyData",BASEURL];
 
    }
    if ([self.navigationItem.title containsString:@"续卡"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getCardRenewData",BASEURL];
        
    }

    if ([self.navigationItem.title containsString:@"升级"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getCardUpgradeData",BASEURL];
        
    }

    if ([self.navigationItem.title containsString:@"消费"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getConsumData",BASEURL];
        
    }

    if ([self.navigationItem.title containsString:@"现金支付"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getTallyData",BASEURL];
        
    }

    
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:[NSString stringWithFormat:@"%ld",self.index] forKey:@"index"];

    [paramer setValue:date forKey:@"date"];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    
    NSLog(@"---%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
       
        NSLog(@"---%@",result);
        
        if (_index ==1) {
                [self.dataSourse_A removeAllObjects];

                self.dataSourse_A = [result[@"list"] mutableCopy];

            totalMoney.text = [NSString stringWithFormat:@"总金额：%.2f元",[[NSString getTheNoNullStr:result[@"sum"] andRepalceStr:@"0"] floatValue]];
            
        }else{
                [self.dataSourse_A addObjectsFromArray:result[@"list"]];
                
        }
        
        
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];

    }];
    
    
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
