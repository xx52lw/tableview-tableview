//
//  LWGRTableView.m
//  LWTableViewContentTableView
//
//  Created by liwei on 2018/5/22.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "LWGRTableView.h"


@implementation LWGRTableView

/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


@end
