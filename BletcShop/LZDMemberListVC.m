//
//  LZDMemberListVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/19.
//  Copyright © 2017年 bletc. All rights reserved.
//

#define ORANGECOLOR RGB(254,177,130)
#define LIGHTGRAYCOLOR RGB(229,229,229)
#define WHITEWIDTH 310


#import "LZDMemberListVC.h"
#import "DOPDropDownMenu.h"
#import "LZDMemberCell.h"
#import "pushView.h"
#import "ValuePickerView.h"
#import "VIPInfoVCS.h"
#import "VIPBirthNoticeVC.h"
#import "PickReasonView.h"

#import "LZDDopDownView.h"


#import "UIImageView+WebCache.h"
#import "AllMessageListViewVC.h"

typedef NS_ENUM(NSInteger,ScreenType) {
    
    sum,
    count,
    age,
    extra
    
};//筛选类型


@interface LZDMemberListVC ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
{
    LZDButton *sex_old_btn;
    
   UIPickerView *datePicker;
    
    NSString *lzd_mon;
    NSString *lzd_day;
    
    NSInteger all_day;
    
    UIView *picker_backView;
    
    NSString *select_date;//所选的日期
    SDRefreshHeaderView *_refreshheader;
    SDRefreshFooterView *_refreshFooter;

}
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UITableView *table_View;
@property (strong, nonatomic) IBOutlet UIButton *screenBtn;


@property(nonatomic,strong)UIButton *oldBtn;
@property(nonatomic,strong)NSArray *dopMenuData_A;
@property(strong,nonatomic)pushView *myPushView;
@property(strong,nonatomic)UIView *screenBackView;

@property(nonatomic,strong)PickReasonView *pickReasonView;

@property(nonatomic,strong)NSMutableArray*btn_mut_A;

@property(nonatomic,strong)NSArray*search_A;

@property(nonatomic,strong)UIDatePicker *datePicker;//日期选择器

@property(nonatomic,strong)NSArray*profession_A;//职业

@property(nonatomic,strong)NSArray*hobby_A;//爱好
@property(nonatomic,strong)NSArray*festival_A;//节日

@property(nonatomic,strong)ValuePickerView *valuePickView;

@property(nonatomic,assign)NSInteger pageIndex;//页码


@property(nonatomic,strong)NSMutableArray *data_Muta_A;

@property(nonatomic,strong)NSMutableDictionary *extra_screen_Dic;//其他筛选条件
@property(nonatomic,copy)NSString *selectOrder_s;//筛选条件,如上到下


@property ScreenType s_type;


@end

@implementation LZDMemberListVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    self.pageIndex = 1;
    lzd_mon = @"1月";
    lzd_day = @"1日";
    all_day = 31;
    self.selectOrder_s =@"desc";
    
    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
    self.pickReasonView = [[PickReasonView alloc]init];

    
    self.footView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 48);
    [self.view addSubview:_footView];
    

    
    
    LZDDopDownView *menu = [[LZDDopDownView alloc]initWithOrigin:CGPointMake(0, 64) andHeight:44 andSuperView:self.view];
    
    menu.data_source_A = self.dopMenuData_A;
    
    [menu selectDefalutIndexPath];
    
    [self.view addSubview:menu];

    __block typeof(self) blockSelf = self;
    
    menu.selectBlock = ^(NSInteger section, NSInteger row) {
      
        blockSelf.pageIndex = 1;

        blockSelf.s_type = section;
    
        if (row ==0) {
            blockSelf.selectOrder_s =@"desc";


        }else if (row==1){
            blockSelf.selectOrder_s =@"asc";

        }else{
            blockSelf.selectOrder_s =@"";
 
        }
        
        
        
        [blockSelf getDataRequest];
        
    };
    
    
    

    
    
    LZDButton *addbtn = [LZDButton creatLZDButton];
    addbtn.frame = CGRectMake(SCREENWIDTH-74.5-14, SCREENHEIGHT-self.tabBarController.tabBar.height-15-74.5, 74.5, 74.5);
    [addbtn setBackgroundImage:[UIImage imageNamed:@"优惠推送"] forState:0];
    [self.view addSubview:addbtn];
    
    addbtn.block = ^(LZDButton *sender) {
     
        pushView *myview=[[pushView alloc]initWithBtnFrame:sender.frame];

        [[UIApplication sharedApplication].keyWindow addSubview:myview];
        [myview pushButton];
        
        self.myPushView = myview;
        
        
        
        myview.btnClickBlock = ^(UIButton *sender) {
          
            [self.myPushView pushButton];

            NSLog(@"----%ld",sender.tag);
            
//            if (sender.tag ==0) {
//
//
//                self.oldBtn = sender;
//
//                self.table_View.editing = !self.table_View.isEditing;
//
//                CGRect footViewFrame = _footView.frame;
//
//                if (self.table_View.editing) {
//
//                    footViewFrame.origin.y = SCREENHEIGHT -49;
//                    [UIView animateWithDuration:0.3 animations:^{
//                        _footView.frame = footViewFrame;
//
//                    }];
//
//                }else{
//                    footViewFrame.origin.y = SCREENHEIGHT;
//                    [UIView animateWithDuration:0.3 animations:^{
//                        _footView.frame = footViewFrame;
//
//                    }];
//                }
//
//
//
//                self.tabBarController.tabBar.hidden = self.table_View.isEditing;
//
//
//
//
//            }
            if (sender.tag==0) {
                PUSH(AllMessageListViewVC)
            }
            
            if (sender.tag==1) {
                PUSH(VIPBirthNoticeVC)
            }
        };

    };
   
    
    
    if (!self.screenBackView) {
        [self creatScreenView];
    }
    
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.pageIndex=1;

        //请求数据
        [tempSelf getDataRequest];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.table_View];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.pageIndex++;
        //数据请求

        [tempSelf getDataRequest];
        
    };

    
   [self getDataRequest];
    
}

-(void)creatScreenView{
    
    UIView *screenBackView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
    screenBackView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.2);
    screenBackView.tag =999;
    [[UIApplication sharedApplication].keyWindow addSubview:screenBackView];
    self.screenBackView = screenBackView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenHide:)];
    
    [screenBackView addGestureRecognizer:tap];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-WHITEWIDTH, 0, WHITEWIDTH, SCREENHEIGHT)];

    whiteView.backgroundColor = [UIColor whiteColor];
    [_screenBackView addSubview:whiteView];
    
    
    
    

    
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, whiteView.width, 17)];
    titleLab.text = @"筛选条件";
    titleLab.textColor = RGB(51,51,51);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18];
    [whiteView addSubview:titleLab];
    

    NSArray *title_A =@[@"性别",@"生日",@"行业",@"爱好"];
    

    
    
    self.btn_mut_A = [NSMutableArray array];
    
    
    
    
    
    for (int i = 0; i <self.search_A.count; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom+14+103*i, whiteView.width, 1)];
        line.backgroundColor = RGB(240, 240, 240);
        [whiteView addSubview:line];
        
        UILabel *sexLab = [[UILabel alloc]initWithFrame:CGRectMake(15, line.bottom+15, whiteView.width, 13)];
        sexLab.text = title_A[i];
        sexLab.textColor = RGB(119,119,119);
        sexLab.textAlignment = NSTextAlignmentLeft;
        sexLab.font = [UIFont systemFontOfSize:14];
        [whiteView addSubview:sexLab];
        
    
        __block typeof(self) blockSelf = self;

        NSMutableArray *muta_A = [NSMutableArray array];
        
        for (int j = 0; j<[_search_A[i] count] ; j++) {
            
            LZDButton *btn = [LZDButton creatLZDButton];
            
            btn.frame = CGRectMake(16+(85+13)*j, sexLab.bottom +15, 85, 45);
            btn.section = i;
            btn.row = j;
            btn.backgroundColor = LIGHTGRAYCOLOR;

           
            btn.layer.cornerRadius =5;
            btn.layer.masksToBounds = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitle:_search_A[i][j] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
            [whiteView addSubview:btn];
            
            
            if (btn.section ==0) {
                if ([blockSelf
                     .extra_screen_Dic[@"sex"] isEqualToString:btn.titleLabel.text]) {
                    btn.backgroundColor =ORANGECOLOR;

                    sex_old_btn = btn;

                }
            }
            
            if (btn.section == 1) {
                NSString *birth =blockSelf
                .extra_screen_Dic[@"birth"];
                
                if (birth.length !=0) {
                    btn.backgroundColor =ORANGECOLOR;
                    
                    NSArray *m_d = [birth componentsSeparatedByString:@"-"];
                    

                    
                    if (btn.row ==0) {
                        [btn setTitle:[NSString stringWithFormat:@"%@月",m_d[0]] forState:UIControlStateNormal];

                    }else{
                        [btn setTitle:[NSString stringWithFormat:@"%@日",m_d[1]] forState:UIControlStateNormal];

                    }
                    

                }
            }
            
            
            if (btn.section ==2) {
           NSString *occupation =blockSelf
                .extra_screen_Dic[@"occupation"];
                
                if (occupation.length !=0) {
                    btn.backgroundColor =ORANGECOLOR;

                    [btn setTitle:occupation forState:UIControlStateNormal];

                }
            }
            
            if (btn.section ==3) {
                NSString *hobby =blockSelf
                .extra_screen_Dic[@"hobby"];
                
                if (hobby.length !=0) {
                    btn.backgroundColor =ORANGECOLOR;
                    
                    [btn setTitle:hobby forState:UIControlStateNormal];
                    
                }
            }
            
            [muta_A addObject:btn];
            
            btn.block = ^(LZDButton *sender) {
              
                //性别选择
                if (sender.section==0) {
                

                    if (sender != sex_old_btn) {
                        sender.backgroundColor =ORANGECOLOR;
                        sex_old_btn.backgroundColor =LIGHTGRAYCOLOR;
                        sex_old_btn = sender;
                        
                        
                        [blockSelf.extra_screen_Dic setValue:[sender titleForState:0] forKey:@"sex"];
                    }
                }
                //生日选择
                if (sender.section ==1) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        CGRect frame =  picker_backView.frame;
                        frame.origin.y =SCREENHEIGHT-picker_backView.height;
                        picker_backView.frame = frame;
  
                    }];
                    
                }
                //行业选择
                if (sender.section ==2) {
                    
                  
                    blockSelf.valuePickView.dataSource = self.profession_A;
                    
                    [_valuePickView show];

                    _valuePickView.valueDidSelect = ^(NSString *value) {
                      
                        sender.backgroundColor =ORANGECOLOR;
                        
                        [sender setTitle:[[value componentsSeparatedByString:@"/"] firstObject] forState:0];
                        
                        
                        [blockSelf.extra_screen_Dic setValue:[sender titleForState:0] forKey:@"occupation"];

                        
                    };
                    
                    
                    
                    
                }

                //爱好选择
                if (sender.section ==3) {
                    
                    
                    self.valuePickView.dataSource = self.hobby_A;
                    [_valuePickView show];
                    
                    _valuePickView.valueDidSelect = ^(NSString *value) {
                        
                        sender.backgroundColor =ORANGECOLOR;
                        
                        [sender setTitle:[[value componentsSeparatedByString:@"/"] firstObject] forState:0];
                        
                        [blockSelf.extra_screen_Dic setValue:[sender titleForState:0] forKey:@"hobby"];

                        
                    };
                    
                    
                    
                    
                }

                
            };
        }
        
        
        [self.btn_mut_A addObject:muta_A];
        
    }
    
   
    
    for (int i = 0; i <2; i++) {
        LZDButton *btn = [LZDButton creatLZDButton];
        btn.frame = CGRectMake(((whiteView.width-1)/2+1)*i, SCREENHEIGHT-50, (whiteView.width-1)/2, 50);
        btn.tag = i;
        btn.backgroundColor = RGB(241,122,18);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        if ( i ==0) {
            [btn setTitle:@"重置" forState:0];
            
            
        }else{
            [btn setTitle:@"确定" forState:0];
           
            
        }
        [whiteView addSubview:btn];
        
        btn.block = ^(LZDButton *sender) {
            
            if (sender.tag ==0) {
                
                for (int i = 0; i <_btn_mut_A.count; i ++) {
                    
                    for (int j = 0; j <[_btn_mut_A[i] count]; j ++) {
                        
                        LZDButton *btn = _btn_mut_A[i][j];

                        btn.backgroundColor = LIGHTGRAYCOLOR;
                        [btn setTitle:_search_A[i][j] forState:0];
                        
                       
                        
                    }
                    
                }
                

                [_extra_screen_Dic removeAllObjects];
                sex_old_btn = nil;
                
                
                [datePicker selectRow:0 inComponent:0 animated:NO];
                [datePicker selectRow:0 inComponent:1 animated:NO];
                select_date = @"1月-1日";

                
            }
            
            
            if (sender.tag ==1) {
                
                NSLog(@"_extra_screen_Dic----%@",_extra_screen_Dic);

                if (_extra_screen_Dic.count) {
                    [self searchBtn:_screenBtn];
                    
                    _pageIndex = 1;
                    _s_type = extra;
                    [self getDataRequest];
                }else{
                    
                    [self showHint:@"请选择筛选条件"];
                    
                }
                
             
            }
        };
        
    }
    
    
    //创建日期选择器
    
    picker_backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 200+40)];
    picker_backView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.2);
    
    [screenBackView addSubview:picker_backView];
    
    
    UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenBackView.width, 40)];
    toolBar.backgroundColor = RGB(238, 238, 238);
    [picker_backView addSubview:toolBar];
    
    
    //完成按钮
    
    LZDButton *finishBtn = [LZDButton creatLZDButton];
    finishBtn.frame = CGRectMake( picker_backView.width - 70, 5, 70, 30);

    finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [toolBar addSubview:finishBtn];
    finishBtn.block = ^(LZDButton *sender) {
        
        NSArray *date_A = [select_date componentsSeparatedByString:@"-"];
        
        
        for (int i = 0; i <date_A.count; i++) {
            LZDButton *btn = self.btn_mut_A[1][i];
            [btn setTitle:date_A[i] forState:0];
            btn.backgroundColor =ORANGECOLOR;

        }
        
//        NSString *year = date_A[0];
        NSString *month = date_A[0];
        NSString *day = date_A[1];

//        year= [year substringToIndex:4];
        month= [month substringToIndex:2];
        day= [day substringToIndex:2];

        NSString *y_m_d = [NSString stringWithFormat:@"%d-%d",[month intValue],[day intValue]];
        
        NSLog(@"----%@",y_m_d);
        
        [self.extra_screen_Dic setValue:y_m_d forKey:@"birth"];


        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame =  picker_backView.frame;
            frame.origin.y =SCREENHEIGHT;
            picker_backView.frame = frame;
        }];

        
    };
    
    //取消按钮
    LZDButton *cancelBtn = [LZDButton creatLZDButton];
    cancelBtn.frame = CGRectMake(0, 5, 70, 30);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [toolBar addSubview:cancelBtn];
    

    cancelBtn.block = ^(LZDButton *sender) {
      [UIView animateWithDuration:0.3 animations:^{
         
          CGRect frame =  picker_backView.frame;
          frame.origin.y =SCREENHEIGHT;
          picker_backView.frame = frame;
      }];
        
    };
  
    
    
    
    
//    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, picker_backView.height-40)];
    
    datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, picker_backView.height-40)];
    datePicker.backgroundColor= [UIColor whiteColor];

    datePicker.delegate = self;
    datePicker.dataSource = self;
    
    
//
//    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//
//
//    datePicker.datePickerMode =UIDatePickerModeDate;
//
//
//    datePicker.maximumDate= [NSDate date];
//
//    datePicker.date = datePicker.maximumDate;
    
    [picker_backView addSubview:datePicker];
    
//    [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    

//    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
//    [dateformatter setDateFormat:@"MM月-dd日"];
//
//    select_date = [dateformatter stringFromDate:datePicker.date];
  
    select_date = @"1月-1日";
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component ==0) {
        
        return 12;
    }else{
        
        
        
        return all_day;
        
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component ==0) {
        return [NSString stringWithFormat:@"%ld月",row+1];
    }else{
        return [NSString stringWithFormat:@"%ld日",row+1];

    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
   
    
    if (component ==0) {
        lzd_mon= [NSString stringWithFormat:@"%ld月",row+1];
        
        switch (row+1) {
            case 1:
            case 3:
             case 5:
              case 7:
                case 8:
                case 10:
                case 12:
                
                all_day = 31;
                
                break;
                
            case 6:
            case 9:
            case 11:
            
                all_day = 30;
                
                break;
            case 2:
                
                all_day = 29;
                
                break;
                
            default:
                break;
        }
       
        
        [pickerView reloadComponent:1];

        
    }else{
        lzd_day= [NSString stringWithFormat:@"%ld日",row+1];
        
    }
    select_date = [NSString stringWithFormat:@"%@-%@",lzd_mon,lzd_day];

    
}

//-(void)dateChange:(UIDatePicker*)pick{
//
//    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
//    [dateformatter setDateFormat:@"yyyy年-MM月-dd日"];
//
//    select_date = [dateformatter stringFromDate:pick.date];
//
//    NSLog(@"---%@", pick.date);
//}

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
    return self.data_Muta_A.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    LZDMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCellID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LZDMemberCell" owner:self options:nil] firstObject];
        
    }
    
    if (self.data_Muta_A.count) {
        NSDictionary *dic= _data_Muta_A[indexPath.row];
    
        
        NSString *name = [NSString getTheNoNullStr:dic[@"name"] andRepalceStr:@""];
        name = name.length==0?[NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@""]:name;
        
        
        cell.nameLab.text = [NSString stringWithFormat:@"名称:%@",name];
        
        
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        
        
        cell.datetime.text = @"";
        
        if (self.s_type ==extra) {
            
            cell.cardTypelab.text = cell.consumeLab.text= @"";
            
        }else if(_s_type ==sum){
            
            cell.cardTypelab.text = [NSString stringWithFormat:@"消费卡种:%@",[NSString getTheNoNullStr:dic[@"card_type"] andRepalceStr:@"会员卡"]];
            
            
            cell.consumeLab.text = [NSString stringWithFormat:@"消费金额:%.2f元",[dic[@"sum"] floatValue]];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.consumeLab.text];
            
            
            [attr setAttributes:@{NSForegroundColorAttributeName:RGB(51,51,51),NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 5)];
            
            cell.consumeLab.attributedText = attr;

 
            
        }else if (_s_type ==count){
            
            cell.cardTypelab.text = [NSString stringWithFormat:@"消费卡种:%@",[NSString getTheNoNullStr:dic[@"card_type"] andRepalceStr:@"会员卡"]];
            
            
            cell.consumeLab.text = [NSString stringWithFormat:@"消费次数:%@",dic[@"count"]];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.consumeLab.text];
            
            
            [attr setAttributes:@{NSForegroundColorAttributeName:RGB(51,51,51),NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 5)];
            
            cell.consumeLab.attributedText = attr;


        }else if(_s_type ==age){
            cell.cardTypelab.text = cell.consumeLab.text= @"";

            cell.datetime.text = [NSString stringWithFormat:@"办卡时间:%@",[dic[@"datetime"] substringToIndex:10]];
            
        }
        

        
    
    
    
       }

    return cell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_table_View.isEditing) {
        PUSH(VIPInfoVCS)
        vc.infoDic =self.data_Muta_A[indexPath.row];
    }
   
    
}

- (IBAction)searchBtn:(UIButton *)sender {
    NSLog(@"====%ld",sender.tag);//搜索icon
    if (sender.tag==1) {
        
        sender.selected = !sender.isSelected;
        
        if (sender.isSelected) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = _screenBackView.frame;
                frame.origin.x = 0;
                _screenBackView.frame = frame;
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = _screenBackView.frame;
                frame.origin.x = SCREENWIDTH;
                _screenBackView.frame = frame;
                
            }];
        }
    }else{
        //搜索的逻辑
       
        
    }
    
    
}


-(void)screenHide:(UITapGestureRecognizer*)tap{
    
    CGPoint point = [tap locationInView:_screenBackView];
  

    
    
    if (point.x<=SCREENWIDTH-WHITEWIDTH || point.y <=64) {
        
        [self searchBtn:_screenBtn];
        
        
    }

    
    
}

#pragma mark 数据请求

-(void)getDataRequest{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/member/getList",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    
    
    [paramer setValue:_selectOrder_s forKey:@"order"];

    
    if (self.s_type ==sum) {
        
        [paramer setValue:@"consum_sum" forKey:@"type"];
        
    }else if (_s_type ==count){
        [paramer setValue:@"consum_count" forKey:@"type"];

    }else if (_s_type ==age){
        
        [paramer setValue:@"member_age" forKey:@"type"];

        
    }else if (_s_type ==extra){
        
        
        [paramer setValue:@"extra" forKey:@"type"];
        
        NSString *json_s = [NSString dictionaryToJson:_extra_screen_Dic];
        
        [paramer setValue:json_s forKey:@"order"];

    }
    
   
    
    [paramer setValue:[NSString stringWithFormat:@"%ld",_pageIndex] forKey:@"index"];


    NSLog(@"paramer===%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"---%@",result);
        
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
        if (_pageIndex==1) {
            
            [self.data_Muta_A removeAllObjects];
            
            self.data_Muta_A = [result mutableCopy];
        }else{
            
            [self.data_Muta_A addObjectsFromArray:result];
        }
        
        
        [self.table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];

    }];

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if (!self.screenBackView) {
        [self creatScreenView];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self.screenBackView removeFromSuperview];
    self.screenBackView = nil;
    
}

- (IBAction)footBtnClick:(UIButton *)sender {
    
    
    if (sender.tag==1) {
        
        
        
        _pickReasonView.title = @"选择节日";
        _pickReasonView.dataSource =self.festival_A ;
        _pickReasonView.mutab_select = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:_pickReasonView];
        
        
        
        __block typeof(self) blockSlef = self;
        
        _pickReasonView.sureBtnClick = ^(NSArray *value_A) {
            
            blockSlef.myPushView.btnClickBlock(blockSlef.oldBtn);
            
            NSLog(@"value_A--%@",value_A);
        };
        [self.pickReasonView show];

        
    }else{
        
        sender.selected = !sender.isSelected;
        
        if (sender.isSelected) {
            [self.data_Muta_A enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self.table_View selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }];
        }else{
            [self.table_View reloadData];
        }
        
       
        
       
        
    }
    
}



#pragma mark 懒加载



-(NSMutableDictionary *)extra_screen_Dic{
    if (!_extra_screen_Dic) {
        _extra_screen_Dic = [NSMutableDictionary dictionary];
    }
    return _extra_screen_Dic;
}

-(NSMutableArray *)data_Muta_A{
    if (!_data_Muta_A) {
        _data_Muta_A = [NSMutableArray array];
    }
    return _data_Muta_A;
}
-(ValuePickerView *)valuePickView{
    if (!_valuePickView) {
        _valuePickView = [[ValuePickerView alloc]init];
    }
    return _valuePickView;
}
-(NSArray *)festival_A{
    if (!_festival_A) {
        _festival_A =@[@"元旦",
                       @"情人节",
                       @"妇女节",
                       @"植树节",
                       @"消费者权益日",
                       @"愚人节",
                       @"劳动节",
                       @"青年节",
                       @"护士节",
                       @"儿童节",
                       @"建党节",
                       @"建军节",
                       @"教师节",
                       @"孔子诞辰",
                       @"国庆节",
                       @"老人节",
                       @"联合国日",
                       @"平安夜",
                       @"圣诞节"];
    }
    return _festival_A;
}
-(NSArray *)hobby_A{
    
    if (!_hobby_A) {
        
        
        _hobby_A = @[@"舞蹈",@"瑜伽",@"篮球",@"户外",@"跑步",@"游泳",@"健身",@"轮滑",@"散步",@"滑雪",@"爬山",@"电影",@"旅行",@"美术",@"音乐",@"阅读",@"写作",@"书法",@"魔术",@"K歌",@"美食",@"网游",@"手游",@"桌游",@"聚会",@"追剧",@"网购",@"睡觉",@"摄影",@"乐器",@"星座",@"咖啡",@"棋牌",@"品茶",@"钓鱼",@"花鸟",@"宠物",@"动漫",@"金融",@"其它"];
    }
    return _hobby_A;
    
}
-(NSArray*)profession_A{
    if (!_profession_A) {
        _profession_A = @[
                     @"销售",@"市场",@"人力资源",@"行政",@"公关",@"客服",@"采购",@"技工",@"公司职员",@"职业经理人",@"私营企业主",@"中层管理者",@"自由职业者",
                     @"开发工程师",@"测试工程师",@"设计师",@"运营师",@"产品经理",@"风控安全",@"个体/网店",
                     @"编辑策划",@"记者",@"艺人",@"经纪人",@"媒体工作者",
                     @"咨询",@"投行",@"保险",@"金融分析师",@"财务",@"风险管理",@"风险投资人",
                     @"学生",@"留学生",@"大学生",@"研究生",@"博士",@"科研人员",@"教师",
                     @"医生",@"护士",@"宠物医生",@"医学研究",
                     @"公务员",@"事业单位",@"军人",@"律师",@"警察",@"国企工作者",@"运动员",
                     @"技术研发",@"技工",@"质检",@"建筑工人",@"装修工人",@"建筑设计师",
                     @"厨师",@"服务员",@"收银",@"导购",@"保安",@"乘务人员",@"驾驶员",@"航空人员",@"空乘",
                     @"导游",@"快递员(含外卖)",@"美容美发",@"家政服务",@"婚庆摄影",@"运动健身",
                     @"其他"
                     ];
    }
    return _profession_A;
}
-(NSArray *)search_A{
    if (!_search_A) {
        _search_A =@[@[@"男",@"女"],@[@"月",@"日"],@[@"请选择"],@[@"请选择"]];
    }
    return _search_A;
}

-(NSArray *)dopMenuData_A{
    if (!_dopMenuData_A) {
        _dopMenuData_A = @[
                           @{@"title":@"消费额度",@"content":@[@"由高到低",@"由低到高"]},
                           @{@"title":@"消费次数",@"content":@[@"由高到低",@"由低到高"]},
                           @{@"title":@"会员时间长度",@"content":@[@"由高到低",@"由低到高"]}
                           
                           ];
    }
    return _dopMenuData_A;
}





@end
