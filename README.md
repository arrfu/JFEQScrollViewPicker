# JFEQScrollViewPicker

轮播按钮，滚动菜单  scrollView menu

1.使用接口：   

<pre><oc>

@protocol JFEQScrollViewDelegate <NSObject>

-(void)scrollButtonClickIndex:(NSInteger)index;

@end

-@property (nonatomic,unsafe_unretained)id <JFEQScrollViewDelegate> delegate;
</oc></pre>

2.使用例子：   

添加轮播按钮    

<pre><oc>

JFEQScrollViewPicker *eqScrollView = [[JFEQScrollViewPicker alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 63)];
eqScrollView.delegate = self;
[self.view addSubview:eqScrollView];  

#pragma mark - 轮播按钮回调
-(void)scrollButtonClickIndex:(NSInteger)index{
    NSLog(@"index = %d",index);
}

</oc></pre>
    
3.效果：   

![轮播按钮效果图](scrollViewPicker.gif)
