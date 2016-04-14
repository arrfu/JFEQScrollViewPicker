//
//  LXEQScrollViewPicker.h
//
//
//  Created by arrfu on 16/4/14.
//  Copyright © 2016年 TRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFEQScrollViewDelegate <NSObject>

-(void)scrollButtonClickIndex:(NSInteger)index;

@end

@interface JFEQScrollViewPicker : UIScrollView



@property (nonatomic,unsafe_unretained)id <JFEQScrollViewDelegate> delegate;

@end
