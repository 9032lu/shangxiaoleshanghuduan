//
//  PickDateTimeView.m
//  BletcShop
//
//  Created by Bletc on 2017/8/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PickDateTimeView.h"


@interface PickDateTimeView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *start,*end;
}
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,copy)NSString *value;
@end
@implementation PickDateTimeView

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
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-300-64, SCREENWIDTH, 300)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 56)];
    title.text = @"请选择营业时间";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = RGB(0,0,0);
    title.font = [UIFont systemFontOfSize:16];
    [backView addSubview:title];
    
    
    UIPickerView *datePick = [[UIPickerView alloc]initWithFrame:CGRectMake(13, title.bottom, title.width-26, backView.height - title.bottom-49)];


    datePick.delegate = self;
    datePick.dataSource = self;
    [backView addSubview:datePick];
    
    self.pickView = datePick;
    

    

    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = RGB(220,220,220);
    line2.bounds  = CGRectMake(0, 0, 21, 1);
    line2.center = datePick.center;
    [backView addSubview:line2];

    
    
    LZDButton *surebtn = [LZDButton creatLZDButton];
    surebtn.frame = CGRectMake(0, backView.height-49, SCREENWIDTH, 49);
    [surebtn setTitle:@"确定" forState:0];
    surebtn.titleLabel.font = [UIFont systemFontOfSize:15];
    surebtn.backgroundColor = RGB(241,122,18);
    [backView addSubview:surebtn];
    
    surebtn.block = ^(LZDButton *sender) {
        
        NSLog(@"---surebtn");
        

              self.sureBtnClick(self.value);
        [self removeSelfFromSupView];
    };
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataSource.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componentz{
   
    return [self.dataSource[componentz] count];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 31;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 31)];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:view.bounds];
        lab.tag = 999;
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
    
    }
    
    UILabel *lab = (UILabel*)[view viewWithTag:999];
    
        lab.text = self.dataSource[component][row];

    return view;
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component==0) {
        start = _dataSource[component][row];
    }
    if (component==1) {
        end = _dataSource[component][row];
    }


    self.value = [NSString stringWithFormat:@"%@-%@",start,end];
    
    NSLog(@"%@/%ld_%@/%ld-----%@",start,row,end,component,_value);
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    
    [self.pickView reloadAllComponents];
    
    [self.pickView selectRow:9 inComponent:0 animated:NO];
    [self.pickView selectRow:18 inComponent:1 animated:NO];

    start = _dataSource[0][9];
    end = _dataSource[1][18];

    self.value = [NSString stringWithFormat:@"%@-%@",start,end];

    
}
- (void)show
{
    
    
    CGRect frame = self.frame;
    if (frame.origin.y == SCREENHEIGHT) {
        frame.origin.y = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
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
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = selfFrame;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    
    
}


@end
