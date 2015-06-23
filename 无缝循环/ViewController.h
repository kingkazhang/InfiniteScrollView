//
//  ViewController.h
//  无缝循环
//
//  Created by Imanol on 15/5/28.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)  UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

