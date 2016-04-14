//
//  ViewController.m
//  JFEQScrollViewPicker
//
//  Created by arrfu on 16/4/14.
//  Copyright © 2016年 JF. All rights reserved.
//

#import "ViewController.h"
#import "JFEQScrollViewPicker.h"

@interface ViewController ()<JFEQScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加轮播按钮
    JFEQScrollViewPicker *eqScrollView = [[JFEQScrollViewPicker alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 63)];
    eqScrollView.delegate = self;
//    eqScrollView.backgroundColor = [UIColor grayColor]; // 游标颜色
    [self.view addSubview:eqScrollView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
   
}

#pragma mark - 轮播按钮回调
-(void)scrollButtonClickIndex:(NSInteger)index{
    NSLog(@"index = %d",index);
}
@end
