//
//  Calculator.m
//  Android 5 Calculator
//
//  Created by Kyon on 15/5/9.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

- (void)dealloc {
    [_arr release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arr = [NSMutableArray new];
        _equalBool = NO;
        
        //状态栏背景
        UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        [statusBar setBackgroundColor:[UIColor colorWithRed:0/255.0 green:189/255.0 blue:210/255.0 alpha:1]];
        [self addSubview:statusBar];
        [statusBar release];
        
        //结果面板
        UIView *resultArea = [[UIView alloc] initWithFrame:CGRectMake(0, statusBar.frame.size.height, frame.size.width, (frame.size.height-statusBar.frame.size.height)*0.38)];
        [resultArea setBackgroundColor:[UIColor whiteColor]];
        //算式区
        UILabel *formula = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, resultArea.frame.size.width-40, resultArea.frame.size.height/2)];
        [formula setTag:100];
        [formula setFont:[UIFont systemFontOfSize:50]];
        [formula setAdjustsFontSizeToFitWidth:YES];
        [formula setTextAlignment:NSTextAlignmentRight];
        [formula setTextColor:[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]];
        [resultArea addSubview:formula];
        [formula release];
        //结果区
        UILabel *result = [[UILabel alloc] initWithFrame:CGRectMake(40, formula.frame.size.height, resultArea.frame.size.width-60, resultArea.frame.size.height/2)];
        [result setTag:101];
        [result setFont:[UIFont systemFontOfSize:32]];
        [result setAdjustsFontSizeToFitWidth:YES];
        [result setTextAlignment:NSTextAlignmentRight];
        [result setTextColor:[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]];
        [resultArea addSubview:result];
        [result release];
        //等号
        UILabel *equal = [[UILabel alloc] initWithFrame:CGRectMake(20-(20+20), result.frame.size.height, 20, result.frame.size.height)];
        [equal setTag:102];
        [equal setFont:[UIFont systemFontOfSize:32]];
        [equal setAdjustsFontSizeToFitWidth:YES];
        [equal setTextColor:[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]];
        [equal setText:@"="];
        [resultArea addSubview:equal];
        [equal release];
        [self addSubview:resultArea];
        [resultArea release];
        
        //数字键盘面板
        UIView *keyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, resultArea.frame.size.height+statusBar.frame.size.height, frame.size.width*0.735, frame.size.height-statusBar.frame.size.height-resultArea.frame.size.height)];
        [keyBoard setBackgroundColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1]];
        //数字按钮
        NSInteger n = 1;
        CGFloat w = 0;
        CGFloat h = keyBoard.frame.size.height*3/4;
        for (NSInteger i = 1; i <= 4; i++, h -= keyBoard.frame.size.height/4) {
            for (NSInteger j = 1; j<= 3; j++, w += keyBoard.frame.size.width/3) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setFrame:CGRectMake(w, h, keyBoard.frame.size.width/3, keyBoard.frame.size.height/4)];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:0/255.0 green:189/255.0 blue:210/255.0 alpha:1] forState:UIControlStateHighlighted];
                [[button titleLabel] setFont:[UIFont systemFontOfSize:32]];
                [[button titleLabel] setAdjustsFontSizeToFitWidth:YES];
                if (i == 1) {
                    switch (j) {
                        case 1:
                            [button setTitle:@"." forState:UIControlStateNormal];
                            break;
                        case 2:
                            [button setTitle:@"0" forState:UIControlStateNormal];
                            break;
                        case 3:
                            [button setTitle:@"=" forState:UIControlStateNormal];
                            break;
                        default:
                            break;
                    }
                }
                else {
                    [button setTitle:[NSString stringWithFormat:@"%ld", n++] forState:UIControlStateNormal];
                }
                [keyBoard addSubview:button];
            }
            w = 0;
        }
        [self addSubview:keyBoard];
        [keyBoard release];
        
        //运算符面板
        UIView *operation = [[UIView alloc] initWithFrame:CGRectMake(keyBoard.frame.size.width, resultArea.frame.size.height+statusBar.frame.size.height, frame.size.width*0.2, frame.size.height-statusBar.frame.size.height-resultArea.frame.size.height)];
        [operation setBackgroundColor:[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]];
        //运算符按钮
        h = 0;
        NSArray *arr = @[@"删除", @"÷", @"×", @"-", @"+"];
        for (NSInteger i = 0; i < 5; i++, h += operation.frame.size.height/5) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(0, h, operation.frame.size.width, operation.frame.size.height/5)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:5/255.0 green:220/255.0 blue:160/255.0 alpha:1] forState:UIControlStateHighlighted];
            [[button titleLabel] setFont:[UIFont systemFontOfSize:20]];
            [[button titleLabel] setAdjustsFontSizeToFitWidth:YES];
            [button setTitle:arr[i] forState:UIControlStateNormal];
            if (i == 0) {
                //对删除键设置手势识别器，长按触发buttonHolded:方法
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonHolded:)];
                [button addGestureRecognizer:longPress];
                [longPress release];
            }
            [operation addSubview:button];
        }
        [self addSubview:operation];
        [operation release];
        
        //高级运算面板按钮
        UIButton *advancedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [advancedButton addTarget:self action:@selector(advancedPanelShow) forControlEvents:UIControlEventTouchUpInside];
        [advancedButton setFrame:CGRectMake(keyBoard.frame.size.width+operation.frame.size.width, resultArea.frame.size.height+statusBar.frame.size.height, frame.size.width-keyBoard.frame.size.width-operation.frame.size.width, frame.size.height-statusBar.frame.size.height-resultArea.frame.size.height)];
        [advancedButton setBackgroundColor:[UIColor colorWithRed:5/255.0 green:220/255.0 blue:160/255.0 alpha:1]];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(advancedPanelShow)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [advancedButton addGestureRecognizer:swipeLeft];
        [swipeLeft release];
        [self addSubview:advancedButton];
        
        //高级运算符面板
        UIView *advancedPanel = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, resultArea.frame.size.height+statusBar.frame.size.height, frame.size.width*3/4, frame.size.height-statusBar.frame.size.height-resultArea.frame.size.height)];
        [advancedPanel setBackgroundColor:[UIColor colorWithRed:5/255.0 green:220/255.0 blue:160/255.0 alpha:1]];
        [advancedPanel setTag:200];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(advancedPanelHide)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [advancedPanel addGestureRecognizer:swipeRight];
        [swipeRight release];
        //高级运算符按钮
        w = 0;
        h = 0;
        arr = @[@"sin", @"cos", @"tan", @"ln", @"log", @"!", @"π", @"e", @"^", @"(", @")", @"√"];
        n = 0;
        for (NSInteger i = 0; i < 4; i++, h += advancedPanel.frame.size.height/4) {
            for (NSInteger j = 0; j < 3; j++, w += advancedPanel.frame.size.width/3) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(w, h, advancedPanel.frame.size.width/3, advancedPanel.frame.size.height/4)];
                [button setTitle:[NSString stringWithFormat:@"%@", arr[n++]] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:0/255.0 green:189/255.0 blue:210/255.0 alpha:1] forState:UIControlStateHighlighted];
                [[button titleLabel] setFont:[UIFont systemFontOfSize:20]];
                [[button titleLabel] setAdjustsFontSizeToFitWidth:YES];
                //                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [advancedPanel addSubview:button];
            }
            w = 0;
        }
        [self addSubview:advancedPanel];
        [advancedPanel release];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)button {
    UILabel *formula = (UILabel *)[self viewWithTag:100];
    UILabel *result = (UILabel *)[self viewWithTag:101];
    UILabel *equal = (UILabel *)[self viewWithTag:102];
    
    if (![button.titleLabel.text isEqualToString:@"="] && _equalBool) {
        [UILabel animateWithDuration:0.3 animations:^{
            [equal setCenter:CGPointMake(equal.center.x-(20+20), equal.center.y)];
        }];
        _equalBool = NO;
    }
    
    if ([button.titleLabel.text isEqualToString:@"="]) {
        if (!_equalBool && ![[self calcString:formula.text] isEqualToString:@"输入错误"]) {
            [UILabel animateWithDuration:0.3 animations:^{
                [equal setCenter:CGPointMake(equal.center.x+(20+20), equal.center.y)];
            }];
            _equalBool = YES;
        }
        if (formula.text.length == 0);
        else {
            [result setText:[self calcString:formula.text]];
        }
    }
    else if ([button.titleLabel.text isEqualToString:@"删除"]) {
        [_arr removeLastObject];
        [formula setText:[_arr componentsJoinedByString:@""]];
    }
    else if ([button.titleLabel.text isEqualToString:@"."] && [_arr count] == 0) {
        [_arr addObject:@"0."];
        [formula setText:[_arr componentsJoinedByString:@""]];
    }
    else {
        [_arr addObject:button.titleLabel.text];
        [formula setText:[_arr componentsJoinedByString:@""]];
    }
    
}

//长按删除按钮清空所有数据
- (void)buttonHolded:(UIButton *)button {
    UILabel *formula = (UILabel *)[self viewWithTag:100];
    UILabel *result = (UILabel *)[self viewWithTag:101];
    UILabel *equal = (UILabel *)[self viewWithTag:102];
    
    [_arr removeAllObjects];
    [formula setText:nil];
    [result setText:nil];
    
    if (_equalBool) {
        [UILabel animateWithDuration:0.3 animations:^{
            [equal setCenter:CGPointMake(equal.center.x-(20+20), equal.center.y)];
        }];
        _equalBool = NO;
    }
}

//弹出高级面板
- (void)advancedPanelShow {
    UIView *advancedPanel = (UIView *)[self viewWithTag:200];
    [UIView animateWithDuration:0.4 animations:^{
        [advancedPanel setCenter:CGPointMake(advancedPanel.center.x-advancedPanel.frame.size.width, advancedPanel.center.y)];
        //        [self bringSubviewToFront:advancedPanel];
    }];
    
}

//收起高级面板
- (void)advancedPanelHide {
    UIView *advancedPanel = (UIView *)[self viewWithTag:200];
    [UIView animateWithDuration:0.4 animations:^{
        [advancedPanel setCenter:CGPointMake(advancedPanel.center.x+advancedPanel.frame.size.width, advancedPanel.center.y)];
        //        [self bringSubviewToFront:advancedPanel];
    }];
    
}

//字符串计算
- (NSString *)calcString:(NSString *)mathString{
    NSMutableString *str = [NSMutableString stringWithString:mathString];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+-×÷"];
    NSCharacterSet *setc = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    
    BOOL flag = 0;
    if ([mathString characterAtIndex:0] == '-') {
        flag = 1;
        NSRange range = NSMakeRange(0, 1);
        [str deleteCharactersInRange:range];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[str componentsSeparatedByCharactersInSet:set]];
    NSMutableArray *arrc = [NSMutableArray arrayWithArray:[str componentsSeparatedByCharactersInSet:setc]];
    [arr removeObject:@""];
    [arrc removeObject:@""];
    
    //判断算式是否合法
    if ([arr count] != [arrc count]+1) {
        return @"输入错误";
    }
    
    if (flag) {
        NSString *first = [NSString stringWithFormat:@"-%@", [arr objectAtIndex:0]];
        [arr replaceObjectAtIndex:0 withObject:first];
    }
    
    for (NSInteger i = 0; i < [arrc count]; i++) {
        NSString *c = [arrc objectAtIndex:i];
        if ([c compare:@"×"] == NSOrderedSame || [c compare:@"÷"] == NSOrderedSame) {
            if ([c compare:@"×"] == NSOrderedSame) {
                CGFloat mul = [[arr objectAtIndex:i] floatValue] * [[arr objectAtIndex:i+1] floatValue];
                [arr removeObjectAtIndex:i];
                [arr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f", mul]];
                [arrc removeObjectAtIndex:i];
            }
            else {
                CGFloat div = [[arr objectAtIndex:i] floatValue] / [[arr objectAtIndex:i+1] floatValue];
                [arr removeObjectAtIndex:i];
                [arr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f", div]];
                [arrc removeObjectAtIndex:i];
            }
            i--;
        }
    }
    
    CGFloat s = [[arr objectAtIndex:0] floatValue];
    for (NSInteger i = 1, j = 0; i < [arr count]; i++, j++) {
        NSString *strc = [arrc objectAtIndex:j];
        NSString *str = [arr objectAtIndex:i];
        if ([strc compare:@"+"] == NSOrderedSame) {
            s += [str floatValue];
        }
        else {
            s -= [str floatValue];
        }
    }
    return [NSString stringWithFormat:@"%g", s];
}

@end
