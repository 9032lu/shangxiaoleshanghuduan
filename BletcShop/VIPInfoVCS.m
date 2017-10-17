//
//  VIPInfoVCS.m
//  BletcShop
//
//  Created by apple on 2017/9/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "VIPInfoVCS.h"
#import "VIPInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LZDChartViewController.h"
#import "VipMoneyRecordRelationVC.h"//升级和续卡记录
#import "CardBuyRecordVC.h"//办卡记录
#import "ChargeRecVC.h"//记录-升级，续卡
#import "VIPHostCardsVC.h"//会员持有的会员卡信息
@interface VIPInfoVCS ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableFootVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *sexy;
@property (weak, nonatomic) IBOutlet UILabel *telPhone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *cardCounts;
@property (weak, nonatomic) IBOutlet UILabel *cardMoney;
@property (weak, nonatomic) IBOutlet UILabel *cardRemain;
@property (nonatomic,strong)NSDictionary *resultDic;
@end

@implementation VIPInfoVCS
- (IBAction)buyCardRecordClick:(id)sender {//VIPHostCardsVC
    PUSH(CardBuyRecordVC)
    vc.title = @"办卡明细";
    vc.dic=self.infoDic;
//    PUSH(VIPHostCardsVC)
//    vc.title = @"办卡明细";
//    vc.dic=self.infoDic;
}

//发送消息
- (IBAction)sendMSG:(id)sender {
    
    Person *p = [Person modalWith:[NSString getTheNoNullStr:self.resultDic[@"info"][@"nickname"] andRepalceStr:@""] imgStr:[NSString getTheNoNullStr:self.resultDic[@"info"][@"headimage"]  andRepalceStr:@""] idstring:self.infoDic[@"uuid"]];
    
    [Database savePerdon:p];
    
    LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
    [chatCtr setHidesBottomBarWhenPushed:YES];
    chatCtr.title=[NSString getTheNoNullStr:self.resultDic[@"info"][@"nickname"] andRepalceStr:@""];
    chatCtr.username = self.infoDic[@"uuid"];
    NSLog(@"chatCtr.username---%@",chatCtr.username);

    chatCtr.chatType = EMChatTypeChat;
    
    [self.navigationController pushViewController:chatCtr animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"会员信息";
    LEFTBACK
    self.tableView.tableHeaderView=_tableHeadView;
    self.tableView.tableFooterView=_tableFootVeiw;
    self.headImage.layer.cornerRadius=27;
    self.headImage.clipsToBounds=YES;
    NSLog(@"infoDic======%@",self.infoDic);
    self.resultDic=[[NSDictionary alloc]init];
    [self postRequestVIPinfos];
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
        NSString *costMoney=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:self.resultDic[@"consum"][@"sum"] andRepalceStr:@"0"]];
        float total=[costMoney floatValue];
        cell.money.text=[NSString stringWithFormat:@"%.2f",total];
    }else{
        cell.title.text=@"充值总额(元)：";
        cell.money.text=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:self.resultDic[@"rec"][@"sum"] andRepalceStr:@"0"]];
    }
    return cell;
}
//获取会员个人信息
-(void)postRequestVIPinfos{
    NSString *url =[[NSString alloc]initWithFormat:@"%@/MerchantType/member/getInfo",BASEURL];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:self.infoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.resultDic=result;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,result[@"info"][@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        self.nickName.text=[NSString stringWithFormat:@"昵称：%@",[NSString getTheNoNullStr:result[@"info"][@"nickname"] andRepalceStr:@""]];
        self.realName.text=[NSString stringWithFormat:@"真实姓名：%@",[NSString getTheNoNullStr:result[@"info"][@"name"] andRepalceStr:@""]];
        self.sexy.text=[NSString stringWithFormat:@"性别：%@",[NSString getTheNoNullStr:result[@"info"][@"sex"] andRepalceStr:@""]];
        self.telPhone.text=[NSString stringWithFormat:@"电话：%@",[NSString getTheNoNullStr:result[@"info"][@"phone"] andRepalceStr:@""]];
        self.address.text=[NSString stringWithFormat:@"地址：%@",[NSString getTheNoNullStr:result[@"info"][@"address"] andRepalceStr:@""]];
        self.cardCounts.text=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:result[@"buy"][@"num"] andRepalceStr:@"0"]];
        
        NSString *costMoney=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:result[@"buy"][@"sum"] andRepalceStr:@"0"]];
        float total=[costMoney floatValue];
        self.cardMoney.text = [NSString stringWithFormat:@"%.2f",total];
//        self.cardMoney.text=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:result[@"buy"][@"sum"] andRepalceStr:@"0"]];
        NSString *remainMoney=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:result[@"buy"][@"remain"] andRepalceStr:@"0"]];
        float total2=[remainMoney floatValue];
        self.cardRemain.text = [NSString stringWithFormat:@"%.2f",total2];
//        self.cardRemain.text=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:result[@"buy"][@"remain"] andRepalceStr:@"0"]];
        NSLog(@"%@", result);
       
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        PUSH(VipMoneyRecordRelationVC)
        vc.title = @"消费明细";
        vc.dic=self.infoDic;
    }else{
        PUSH(ChargeRecVC)
        vc.title = @"充值明细";
        vc.dic=self.infoDic;
    }
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
