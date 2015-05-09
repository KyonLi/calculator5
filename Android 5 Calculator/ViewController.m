//
//  ViewController.m
//  Android 5 Calculator
//
//  Created by Kyon on 15/5/9.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Calculator *cal = [[Calculator alloc] initWithFrame:self.view.frame];
    [[self view] addSubview:cal];
    [cal release];
}

@end
