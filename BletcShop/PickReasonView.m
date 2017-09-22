//
//  PickReasonView.m
//  BletcShop
//
//  Created by Bletc on 2017/8/29.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PickReasonView.h"


@interface PickReasonView ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableViewCell *oldCell;
    
    
    
    NSInteger singleSelect;
}
@property(nonatomic,strong)UITableView *table_View;
@property(nonatomic,copy)NSMutableDictionary *value_mutab;
@property (nonatomic, strong) NSMutableDictionary * select_dic;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *backView;
@end
@implementation PickReasonView
-(NSMutableDictionary *)select_dic{
    if (!_select_dic) {
        _select_dic = [NSMutableDictionary dictionary];
        [_select_dic setValue:@"1" forKey:@"0"];
    }
    return _select_dic;
}

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT)]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.userInteractionEnabled = YES;
        [self addSubview:self.maskView];

        //初始化子视图
        [self initSubViews];
    }
    return self;
}


-(void)initSubViews{
    
    singleSelect = 0;
    
 UIView*  backView =[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 347)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    self.backView = backView;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 56)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = RGB(0,0,0);
    title.font = [UIFont systemFontOfSize:16];
    [backView addSubview:title];
    
    self.titleLab =title;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, title.bottom, title.width, backView.height - title.bottom-49) style:UITableViewStyleGrouped];
    
    tableView.rowHeight = 46;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [backView addSubview:tableView];
    
    self.table_View = tableView;
    
    
    LZDButton *surebtn = [LZDButton creatLZDButton];
    surebtn.frame = CGRectMake(0, backView.height-49, SCREENWIDTH, 49);
    [surebtn setTitle:@"确定" forState:0];
    surebtn.titleLabel.font = [UIFont systemFontOfSize:15];
    surebtn.backgroundColor = RGB(241,122,18);
    [backView addSubview:surebtn];
    
    surebtn.block = ^(LZDButton *sender) {
        
        NSLog(@"---surebtn");
        
        NSArray *keyArray = [self.value_mutab allKeys];
        NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
            
        }];
        
        NSMutableArray *ar= [NSMutableArray array];
        for (NSString *key in sortArray) {
            [ar addObject:self.value_mutab[key]];

        }
        
        NSLog(@"-----%@",sortArray);
        
        self.sureBtnClick(ar);
        [self removeSelfFromSupView];
    };
    
}


-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
    
}


-(NSMutableDictionary *)value_mutab{
    if (!_value_mutab) {
        _value_mutab = [NSMutableDictionary dictionary];
        
        [_value_mutab setValue:self.dataSource[0] forKey:@"0"];
    }
    return _value_mutab;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickcellID"];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickcellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-15-13, (46-15)/2, 15, 15)];
        cell.selected = NO;
        imgView.tag =999;
        imgView.image = [UIImage imageNamed:@"默认sex"];

        [cell.contentView addSubview:imgView];
        
    }
    
    if (self.mutab_select) {
        
        if ([self.select_dic[[NSString stringWithFormat:@"%ld",indexPath.row]] boolValue]) {
            ((UIImageView*)[cell.contentView viewWithTag:999]).image = [UIImage imageNamed:@"选中sex"];
 
            
        }else{
            ((UIImageView*)[cell.contentView viewWithTag:999]).image = [UIImage imageNamed:@"默认sex"];

        }
        
    }else{
        
        cell.tag = indexPath.row;
        
        
        if (indexPath.row == singleSelect) {
            ((UIImageView*)[cell.contentView viewWithTag:999]).image = [UIImage imageNamed:@"选中sex"];

        }else{
            ((UIImageView*)[cell.contentView viewWithTag:999]).image = [UIImage imageNamed:@"默认sex"];
 
        }

        
    }
    
  
    
    cell.textLabel.text = self.dataSource[indexPath.row];

    if (indexPath.row ==self.dataSource.count-1) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        
        [attr setAttributes:@{NSForegroundColorAttributeName : RGB(119,119,119)} range:NSMakeRange(2, cell.textLabel.text.length-2)];
        
        cell.textLabel.attributedText = attr;
    }
    
    return cell;
    
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    
    
    [self.table_View reloadData];
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"-----index =%ld",indexPath.row);
    
    
    
    if (self.mutab_select) {
        
        NSString *row = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        
        
        if ([self.select_dic[row] boolValue]) {
            [self.select_dic setValue:@"0" forKey:row];

            [self.value_mutab removeObjectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            

            
        }else{
            [self.select_dic setValue:@"1" forKey:row];
            
            [self.value_mutab setValue:self.dataSource[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];

            

            
        }
    
       
    }else{
        
        singleSelect = indexPath.row;
        
        
     
        
        [self.value_mutab removeAllObjects];
        [self.value_mutab setValue:self.dataSource[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        
    }
    
    [tableView reloadData];

    
}

- (void)show
{

    
    CGRect frame = self.frame;
    

    if (frame.origin.y == SCREENHEIGHT) {
        frame.origin.y = 0;
        self.frame = frame;
        
        CGRect backFrame = self.backView.frame;
        backFrame.origin.y = SCREENHEIGHT-self.backView.height;

        [UIView animateWithDuration:0.3 animations:^{
            
            self.backView.frame = backFrame;
            
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self removeSelfFromSupView];
}


-(void)removeSelfFromSupView{

    CGRect selfFrame = self.frame;
    if (selfFrame.origin.y == 0) {
        selfFrame.origin.y = SCREENHEIGHT;
        self.frame = selfFrame;

        
        CGRect backFrame = self.backView.frame;
        backFrame.origin.y = SCREENHEIGHT;
   
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backView.frame = backFrame;

        
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }

    
}
@end
