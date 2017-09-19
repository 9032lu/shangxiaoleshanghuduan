//
//  RJGDetailVC.m
//  BletcShop
//
//  Created by Bletc on 16/9/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "RJGDetailVC.h"
#import "RewardPoliceVC.h"
#import "ShopRefferTableViewCell.h"
#import "ShopAppriseMoneyGetVC.h"
@interface RJGDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *num_lab;
    UILabel *sum_lab;
    UILabel *remain_lab;
    __weak LZDButton*tixian;
}
@property(nonatomic,strong)NSArray *data_array;
@end

@implementation RJGDetailVC

-(NSArray*)data_array{
    if (!_data_array) {
        _data_array = [NSArray array];
    }
    return _data_array;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [self postRequestMoney];
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
    label.text=@"奖励明细";
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
    
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-70, 20, 70, 44);
    
    [rightBtn setTitle:@"奖励政策" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:rightBtn];
    
    rightBtn.block = ^(LZDButton *btn){
        NSLog(@"奖励政策");
        PUSH(RewardPoliceVC)
       
        
    };

    
    
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

    
    UILabel *money_lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, SCREENWIDTH, 30)];
    money_lab.text = @"0人";
    money_lab.textColor = [UIColor blackColor];
    money_lab.font = [UIFont systemFontOfSize:20];
    [view3 addSubview:money_lab];
    num_lab = money_lab;
    
    UILabel *m_lab = [[UILabel alloc]initWithFrame:CGRectMake(30, money_lab.bottom, SCREENWIDTH, 15)];
    m_lab.textColor = [UIColor grayColor];
    m_lab.text = @"推荐人数";
    m_lab.font = [UIFont systemFontOfSize:12];
    [view3 addSubview:m_lab];
    
    UILabel *shengyu_lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, SCREENWIDTH, 20)];
    
    shengyu_lab.textColor = [UIColor blackColor];
    shengyu_lab.text = @"0元";
    shengyu_lab.font = [UIFont systemFontOfSize:16];
    [view3 addSubview:shengyu_lab];
    remain_lab = shengyu_lab;
    
    UILabel *c_lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, SCREENWIDTH, 20)];
    
    c_lab.textColor = [UIColor grayColor];
    c_lab.text = @"推荐奖励金";
    c_lab.font = [UIFont systemFontOfSize:12];
    [view3 addSubview:c_lab];
    
    tixian=[LZDButton creatLZDButton];
    tixian.frame=CGRectMake(view3.width-73, 13, 60, 33);
    tixian.layer.cornerRadius=6;
    tixian.clipsToBounds=YES;
    tixian.backgroundColor=NavBackGroundColor;
    [tixian setTitle:@"提现" forState:UIControlStateNormal];
    [tixian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tixian.block = ^(LZDButton*btn){
        ShopAppriseMoneyGetVC *vc=[[ShopAppriseMoneyGetVC alloc]init];
        vc.sum_string=[remain_lab.text componentsSeparatedByString:@"元"][0];//self.sum_string;
        vc.block = ^(){
            [self postRequestMoney];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    [view3 addSubview:tixian];
    if ([self.sum_string floatValue]<=0) {
        tixian.userInteractionEnabled=NO;
        tixian.backgroundColor=RGB(180, 180, 180);
    }
    
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
        
        cell.phoneNumLable.text = dic[@"phone"];
        cell.dateTimeLable.text = dic[@"datetime"];
        
    }
     return cell;
    
}

-(void)postRequestMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/fund/getReferrer",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {

        NSDictionary *dic = [NSDictionary dictionary];
        dic = [result copy];
        NSLog(@"------%@",dic);
        
        if (dic.count>0) {
            remain_lab.text=[NSString stringWithFormat:@"%@元",self.sum_string];//////////
            num_lab.text = [NSString stringWithFormat:@"%@人",dic[@"num"]];
            NSString *remain= [remain_lab.text componentsSeparatedByString:@"元"][0];
            if ([remain floatValue]<=0) {
                tixian.userInteractionEnabled=NO;
                tixian.backgroundColor=RGB(180, 180, 180);
            }else{
                tixian.userInteractionEnabled=YES;
                tixian.backgroundColor=NavBackGroundColor;
            }
            self.data_array = dic[@"info"];
            
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
