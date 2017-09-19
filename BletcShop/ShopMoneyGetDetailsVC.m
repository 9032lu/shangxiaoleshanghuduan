//
//  RJGDetailVC.m
//  BletcShop
//
//  Created by Bletc on 16/9/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopMoneyGetDetailsVC.h"
#import "RewardPoliceVC.h"
#import "ShopRefferTableViewCell.h"
@interface ShopMoneyGetDetailsVC ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *num_lab;
    UILabel *sum_lab;
    UILabel *remain_lab;
    
}
@property(nonatomic,strong)NSArray *data_array;
@end

@implementation ShopMoneyGetDetailsVC

-(NSArray*)data_array{
    if (!_data_array) {
        _data_array = [NSArray array];
    }
    return _data_array;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor darkGrayColor];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
    UIImageView*backImg=[[UIImageView alloc]init];
    backImg.frame=CGRectMake(9, 30, 12, 20);
    backImg.image=[UIImage imageNamed:@"leftArrow"];
    [topView addSubview:backImg];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    label.text=@"提现明细";
    label.font=[UIFont systemFontOfSize:19];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [topView addSubview:label];
    
    LZDButton*backTi=[LZDButton creatLZDButton];
    backTi.frame=CGRectMake(0, 20, SCREENWIDTH*0.2, 44);
    backTi.block = ^(LZDButton*btn){
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    [topView addSubview:backTi];
    

    UIView*red_v =[[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom, SCREENWIDTH, 130)];
    red_v.backgroundColor=NavBackGroundColor;
    [self.view addSubview:red_v];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(30, 30, SCREENWIDTH-60, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 7;
    view1.alpha = 0.4;
    [red_v addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 40, SCREENWIDTH-40, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.cornerRadius = 7;
    view2.alpha = 0.5;
    [red_v addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20, 120)];
    view3.backgroundColor = [UIColor whiteColor];
    view3.layer.cornerRadius = 7;
    [red_v addSubview:view3];
    
    
    UILabel *money_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, SCREENWIDTH, 17)];
    money_lab.text = @"提现笔数";
    money_lab.textAlignment = NSTextAlignmentCenter;
    
    money_lab.textColor = RGB(0,0,0);
    money_lab.font = [UIFont systemFontOfSize:18];
    [view3 addSubview:money_lab];
    sum_lab = money_lab;
    
    //    UILabel *m_lab = [[UILabel alloc]initWithFrame:CGRectMake(30, money_lab.bottom, SCREENWIDTH, 15)];
    //    m_lab.textColor = [UIColor grayColor];
    //    m_lab.text = @"累计金额";
    //    m_lab.font = [UIFont systemFontOfSize:12];
    //    [view3 addSubview:m_lab];
    
    UILabel *count_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 66, SCREENWIDTH, 20)];
    
    count_lab.textColor = RGB(0,0,0);
    count_lab.text = @"0笔";
    count_lab.font = [UIFont systemFontOfSize:21];
    count_lab.textAlignment = NSTextAlignmentCenter;
    [view3 addSubview:count_lab];
    num_lab = count_lab;
    
    //    UILabel *c_lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, SCREENWIDTH, 20)];
    //
    //    c_lab.textColor = [UIColor grayColor];
    //    c_lab.text = @"提现";
    //    c_lab.font = [UIFont systemFontOfSize:12];
    //    [view3 addSubview:c_lab];
    
    //    UILabel *shengyu_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, count_lab.top, view3.width-10, count_lab.height)];
    //    shengyu_lab.textColor = count_lab.textColor;
    //    shengyu_lab.font = count_lab.font;
    //    shengyu_lab.text = @"0元";
    //    shengyu_lab.textAlignment = NSTextAlignmentRight;
    //    [view3 addSubview:shengyu_lab];
    //    remain_lab = shengyu_lab;
    //
    //
    //    UILabel *sy_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, c_lab.top, view3.width-20, c_lab.height)];
    //    sy_lab.textColor = c_lab.textColor;
    //    sy_lab.font = c_lab.font;
    //    sy_lab.textAlignment = NSTextAlignmentRight;
    //    sy_lab.text = @"剩余";
    //    [view3 addSubview:sy_lab];
    //
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, red_v.bottom, SCREENWIDTH, SCREENHEIGHT-red_v.bottom) style:UITableViewStyleGrouped];
    tableView.dataSource= self;
    tableView.delegate = self;
    tableView.rowHeight = 66;
    tableView.backgroundColor = RGB(243, 243, 243);
    tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    self.tableview = tableView;
    
    [self postRequestMoney];
    [self.view bringSubviewToFront:red_v];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString   * CellIdentiferId =  @"ShopRefferCell" ;
    ShopRefferTableViewCell   * cell = [tableView  dequeueReusableCellWithIdentifier: CellIdentiferId];
    if  (!cell){
        NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed : @"ShopRefferTableViewCell" owner : nil options :nil ];
        cell = [ nibs lastObject ];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    };
    
    if (self.data_array.count>0) {
        NSDictionary *dic = _data_array[indexPath.row];
        
        cell.phoneNumLable.text = [NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"0"];
        cell.referPhone.text=@"提现金额";
        cell.registDate.text=dic[@"datetime"];
        CGRect frame=cell.dateTimeLable.frame;
        frame.size.width=250;
        cell.dateTimeLable.frame=frame;
        if ([[NSString getTheNoNullStr:dic[@"state"] andRepalceStr:@""]  isEqualToString:@"wait"]) {
           cell.dateTimeLable.text = @"平台处理中";
        }else if ([[NSString getTheNoNullStr:dic[@"state"] andRepalceStr:@""]  isEqualToString:@"access"]){
           cell.dateTimeLable.text = @"平台已转账";
            
        }else{
            cell.dateTimeLable.text = @"出错!!!";
            
        }
    }
    return cell;
    
}

-(void)postRequestMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/fund/getWithdraw",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [result copy];
        NSLog(@"------%@",dic);
        
        if (dic.count>0) {
            
            num_lab.text = [NSString stringWithFormat:@"%@笔",dic[@"num"]];
            
            self.data_array = dic[@"record"];
            
            if (self.data_array.count>0) {
                
                [self.tableview reloadData];
            }
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
