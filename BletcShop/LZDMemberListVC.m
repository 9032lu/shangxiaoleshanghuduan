//
//  LZDMemberListVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/19.
//  Copyright © 2017年 bletc. All rights reserved.
//



#import "LZDMemberListVC.h"
#import "DOPDropDownMenu.h"
#import "LZDMemberCell.h"
#import "pushView.h"

@interface LZDMemberListVC ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *table_View;

@property(nonatomic,strong)NSArray *dopMenuData_A;
@property(strong,nonatomic)pushView *myPushView;

@end

@implementation LZDMemberListVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;

    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0,64) andHeight:44 andSuperView:self.view];
    menu.delegate = self;
    menu.dataSource = self;
    menu.isClickHaveItemValid = YES;
    [self.view addSubview:menu];
    
    
    

    
    
    LZDButton *addbtn = [LZDButton creatLZDButton];
    addbtn.frame = CGRectMake(SCREENWIDTH-57-14, SCREENHEIGHT-60-57, 57, 57);
    addbtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:addbtn];
    
    addbtn.block = ^(LZDButton *sender) {
     
        pushView *myview=[pushView new];

        [[UIApplication sharedApplication].keyWindow addSubview:myview];
        [myview pushButton];
        
        myview.btnClickBlock = ^(UIButton *sender) {
          
            NSLog(@"----%ld",sender.tag);
        };

    };
   
    
}



-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return self.dopMenuData_A.count;
}

-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    
    return [self.dopMenuData_A[column] count];
    
}

-(NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    return  self.dopMenuData_A[indexPath.column][indexPath.row];
}

-(NSString*)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath{
    return @"";
}

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{

    
    NSLog(@"------%@",self.dopMenuData_A[indexPath.column][indexPath.row]);
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    LZDMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCellID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LZDMemberCell" owner:self options:nil] firstObject];
        
    }
    
    cell.consumeLab.text = @"消费次数：18次";
    
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.consumeLab.text];
    
    
    
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(51,51,51),NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 5)];
    

    cell.consumeLab.attributedText = attr;

    return cell;
}


- (IBAction)searchBtn:(UIButton *)sender {
    NSLog(@"====%ld",sender.tag);
    
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


-(NSArray *)dopMenuData_A{
    if (!_dopMenuData_A) {
        _dopMenuData_A = @[@[@"综合排序",@"消费额度",@"消费额度由高到低",@"消费额度由低到高"],@[@"消费次数",@"消费次数由高到低",@"消费次数由低到高"],@[@"本月新增"]];
    }
    return _dopMenuData_A;
}

@end
