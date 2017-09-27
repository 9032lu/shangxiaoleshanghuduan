//
//  ShopCodeResultOtherVC.m
//  BletcShop
//
//  Created by apple on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopCodeResultOtherVC.h"
#import "PayForTaoCanTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ShopCodeResultOtherVC ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *shophud;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@end

@implementation ShopCodeResultOtherVC
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmBtnClick:(id)sender {
     [self postRequestPayForVipCards:self.postDic];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.confirmBtn.layer.borderColor = [RGB(9,192,132) CGColor];
    self.confirmBtn.layer.borderWidth=1;
    self.confirmBtn.layer.cornerRadius=6;
    self.confirmBtn.clipsToBounds=YES;
    self.tableView.tableHeaderView=self.tableHeadView;
    self.tableView.tableFooterView=self.tableFootView;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
    self.nickName.text=self.dic[@"nickname"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"PayForTaoCanCell";
    PayForTaoCanTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PayForTaoCanTableViewCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,self.dic[@"option_image"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
    cell.name.text=self.dic[@"option_name"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(void)postRequestPayForVipCards:(NSDictionary*)dic{
    //http://101.201.100.191/cnconsum/App/MerchantType/gather/commit
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/commit",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    shophud =[MBProgressHUD showHUDAddedTo:window animated:YES];
    shophud.label.text = @"交易正在进行...";
    
    NSLog(@"%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        printf("result====%s",[[NSString dictionaryToJson:result] UTF8String]);
         [shophud hideAnimated:YES];
        
        if ([result[@"result_code"] integerValue]==1) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收款成功！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(9,192,132) forKey:@"titleTextColor"];
            
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if([result[@"result_code"] integerValue]==-1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"订单失效！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(9,192,132) forKey:@"titleTextColor"];
            
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收款失败！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(9,192,132) forKey:@"titleTextColor"];
            
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        shophud.label.text = @"接口出错404！";
        [shophud hideAnimated:YES afterDelay:0.3];
    }];
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
