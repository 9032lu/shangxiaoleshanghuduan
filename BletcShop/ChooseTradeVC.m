//
//  ChooseTradeVC.m
//  BletcShop
//
//  Created by apple on 2017/8/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChooseTradeVC.h"
#import "EricTradeTableViewCell.h"
@interface ChooseTradeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *bigTradeTableView;
@property(nonatomic)NSInteger bigTradeSelectRow;
@property(nonatomic,strong)NSArray *bigTradeArray;
//
@property (weak, nonatomic) IBOutlet UITableView *smallTradeTableView;
@property(nonatomic,strong)NSMutableArray *smallTradeArray;

@end

@implementation ChooseTradeVC
- (IBAction)dismissVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (IBAction)cancelSeleted:(id)sender {
    if (self.smallTradeArray.count>0) {
        for (int i=0; i<self.smallTradeArray.count; i++) {
            NSMutableDictionary *dic=self.smallTradeArray[i];
            [dic setObject:@"no" forKey:@"choose"];
        }
        [self.smallTradeTableView reloadData];
    }
    
}
- (IBAction)confirmSelected:(id)sender {
    if (self.smallTradeArray.count>0) {
        NSString *string=[NSString string];
        for (int i=0; i<self.smallTradeArray.count; i++) {
            NSMutableDictionary *dic=self.smallTradeArray[i];
            if ([dic[@"choose"] isEqualToString:@"yes"]) {
                string=[NSString stringWithFormat:@"%@%@,",string,dic[@"text"]];
            }
        }
        NSLog(@"%ld",string.length);
        NSLog(@"%@",[string substringToIndex:string.length-1]);
       
        //调用block回传string
        if (string) {
            if (string.length>0) {
                self.resultBlock([string substringToIndex:string.length-1]);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    }else{
        [self showHint:@"请选择您的行业"];
       
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bigTradeArray=[NSArray array];
    self.smallTradeArray=[NSMutableArray array];
    
    self.bigTradeTableView.rowHeight=46;
    self.smallTradeTableView.rowHeight=54;
    
    _bigTradeSelectRow=0;
    //获取大分类接口和小分类接口
    [self postRequestBigTrades];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_bigTradeTableView) {
        return self.bigTradeArray.count;
    }else{
        return self.smallTradeArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.bigTradeTableView) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
        if (indexPath.row==_bigTradeSelectRow) {
            cell.textLabel.textColor=RGB(243, 73, 78);
        }else{
            cell.textLabel.textColor=RGB(51, 51, 51);
        }
        cell.textLabel.text=self.bigTradeArray[indexPath.row][@"text"];
        return cell;
    }else{
        static NSString *resuseIdentify=@"EricTradeCell";
        EricTradeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EricTradeTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tradeLable.text=self.smallTradeArray[indexPath.row][@"text"];
        if ([self.smallTradeArray[indexPath.row][@"choose"] isEqualToString:@"no"]) {
            cell.chooseType.image=[UIImage imageNamed:@"默认sex"];
        }else{
            cell.chooseType.image=[UIImage imageNamed:@"选中sex"];
        }
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.bigTradeTableView) {
        _bigTradeSelectRow=indexPath.row;
        [self.bigTradeTableView reloadData];
        [self postRequestSmallTrades:self.bigTradeArray[indexPath.row][@"id"]];
    }else{
        NSMutableDictionary *dic = self.smallTradeArray[indexPath.row];
        if ([dic[@"choose"] isEqualToString:@"no"]) {
            [dic setObject:@"yes" forKey:@"choose"];
        }else{
            [dic setObject:@"no" forKey:@"choose"];
        }
        [self.smallTradeArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.smallTradeTableView reloadData];
    }
}
-(void)postRequestBigTrades{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/trade/getUp",BASEURL];
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if (result) {
            self.bigTradeArray=result;
            [self.bigTradeTableView reloadData];
            if (self.bigTradeArray.count>0) {
                [self postRequestSmallTrades:self.bigTradeArray[0][@"id"]];
            }
        }
 
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];

}
-(void)postRequestSmallTrades:(NSString *)up_id{
    if ([self.smallTradeArray count]>0) {
        [self.smallTradeArray removeAllObjects];
        [self.smallTradeTableView reloadData];
    }
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/trade/getSub",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:up_id forKey:@"up_id"];//up_id
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result??????%@",result);
        if (result&&[result count]>0) {
            for (int i=0; i<[result count]; i++) {
                NSMutableDictionary *dic=[result[i] mutableCopy];
                [dic setObject:@"no" forKey:@"choose"];
                [self.smallTradeArray addObject:dic];
            }
            [self.smallTradeTableView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
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
