//
//  JFEQScrollViewPicker.m
//
//
//  Created by arrfu on 16/4/14.
//  Copyright © 2016年 TRP. All rights reserved.
//

#import "JFEQScrollViewPicker.h"

#define LocalizedString(key)  NSLocalizedString(key, nil)

@interface JFEQScrollViewPicker()<UIScrollViewDelegate>{
    UIView *selectView; // 选中圆点
    CGFloat scrollViewWidth;
    bool snapping;
}

@property (nonatomic,strong)UIScrollView *eqScrollView;
@end

@implementation JFEQScrollViewPicker

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加视图
        CGRect viewFrame = frame;
        viewFrame.origin.y = 0;
        [self createEqScrollView:viewFrame];
    }
    return self;
}

/**
 * 创建视图
 */
-(void)createEqScrollView:(CGRect)frame{
    
    // 添加音效背景图
    UIImageView *eqSelectBgView = [[UIImageView alloc] initWithFrame:frame];
    eqSelectBgView.image = [UIImage imageNamed:@"img_fun_eq_select_bg"];
    [self addSubview:eqSelectBgView];
    
    // 选中圆点
    selectView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    selectView.center = CGPointMake(frame.size.width/2, frame.size.height-8);
    selectView.layer.cornerRadius = 5;
    selectView.backgroundColor = [UIColor blueColor];
    [eqSelectBgView addSubview:selectView];
    

    self.eqScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.eqScrollView.delegate = self;
    self.eqScrollView.showsHorizontalScrollIndicator = NO;
    self.eqScrollView.showsVerticalScrollIndicator = NO;
    scrollViewWidth = frame.size.width;
    
    CGFloat itemSizeW = 70;
    CGFloat itemSizeH = 44;
    NSArray *titleArray = [NSArray arrayWithObjects:LocalizedString(@"关闭"),LocalizedString(@"自定义"),LocalizedString(@"流行"),LocalizedString(@"重低音"),LocalizedString(@"人声"),LocalizedString(@"摇滚"),LocalizedString(@"古典"),LocalizedString(@"爵士"),LocalizedString(@"舞曲"),LocalizedString(@"电子"), nil];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *scrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scrollBtn.frame = CGRectMake(0, 0, itemSizeW, itemSizeH);
        scrollBtn.tag = i;
        
        scrollBtn.center = CGPointMake(itemSizeW*i+itemSizeW/2*i+frame.size.width/2, 63/2);
        [scrollBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [scrollBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [scrollBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        scrollBtn.backgroundColor = [UIColor clearColor];
        scrollBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [scrollBtn addTarget:self action:@selector(scrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.eqScrollView addSubview:scrollBtn];
        
        if (i == 0) {
            [self scrollBtnClick:scrollBtn];
        }

    }
    
    self.eqScrollView.contentSize = CGSizeMake(1.5*itemSizeW*(titleArray.count-1)+frame.size.width, 63);
    [self addSubview:self.eqScrollView];


}


/**
 * 选中按钮
 */
-(void)scrollBtnClick:(UIButton*)sender{
    NSLog(@"button click");
    
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint point = self.eqScrollView.contentOffset;
        point.x = sender.center.x-scrollViewWidth/2;
        self.eqScrollView.contentOffset = point;
    }];
    
    [self.eqScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [UIButton class]) {
            UIButton *btn = (UIButton*)obj;
            
            if (btn == sender) {
                btn.selected = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                
            }
            else{
                btn.selected = NO;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
            }
        }
    }];
    
    selectView.hidden = NO;
    if (sender.tag == 0) {
        selectView.backgroundColor = [UIColor redColor];
    }
    else{
        selectView.backgroundColor = [UIColor blueColor];

    }
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(scrollButtonClickIndex:)]) {
        [self.delegate scrollButtonClickIndex:sender.tag];
    }
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    selectView.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == 0 && !snapping) {
        [self snapToAnEmotion];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!snapping){
        [self snapToAnEmotion];
    }
}


/**
 * 选择居中按钮
 */
- (void)snapToAnEmotion
{

    snapping = YES;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^ {
        [self setScrollEnabled:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            // 获取需要居中的按钮
            [self.eqScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj class] == [UIButton class]) {
                    UIButton *btn = (UIButton*)obj;
//                    NSLog(@"btn = %@,x = %f",btn.titleLabel.text,btn.center.x);
        
                    CGFloat startX = btn.frame.origin.x - btn.frame.size.width/2-scrollViewWidth/2;
                    CGFloat endX = btn.center.x + btn.frame.size.width/2-scrollViewWidth/2;
//                    NSLog(@"statrX = %f,endX = %f",startX,endX);
        
                    if ((self.eqScrollView.contentOffset.x >= startX) && (self.eqScrollView.contentOffset.x <= endX)) {
                        // 居中动画
                        [self scrollBtnClick:btn];
                        *stop = YES;
                    }
                }
                
            }];

            [self setScrollEnabled:YES];
            snapping = NO;
        });
    });
}


@end
