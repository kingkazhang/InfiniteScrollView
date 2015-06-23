//
//  ViewController.m
//  无缝循环
//
//  Created by Imanol on 15/5/28.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property(strong, nonatomic) NSMutableArray *imageArrays;
@property(strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupData];
}

- (void) setupData{
    
    // 逻辑思路 4‘-1-2-3-4-1’;初始状态先添加正常顺序的四张图
    self.imageArrays = [NSMutableArray arrayWithObjects:@"img_00",@"img_01",@"img_02",@"img_03",@"img_04", nil];
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    //pageControl
    [self.pageControl setNumberOfPages:self.imageArrays.count];
    [self.pageControl setCurrentPage:0];
    
    for(int i = 0; i< _imageArrays.count; i++){
        //该循环添加正常顺序的图片
        CGFloat imageX = i*imageW+imageW;
        CGFloat imageY = 0;
        CGRect frame = CGRectMake(imageX, imageY, imageW, imageH);
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        self.imageView.image = [UIImage imageNamed:[self.imageArrays objectAtIndex:i]];
        [self.scrollView addSubview:self.imageView];
    }
    
    //添加正常循序的第一张到最后，添加正常循序的最后一张在最前面
    UIImageView *firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self.imageArrays lastObject]]];
    firstImageView.frame = CGRectMake(0, 0, imageW, imageH);
    [self.scrollView addSubview:firstImageView];
    
    UIImageView *lastImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self.imageArrays objectAtIndex:0]]];
    lastImageView.frame = CGRectMake(imageW*(self.imageArrays.count+1), 0, imageW, imageH);
    [self.scrollView addSubview:lastImageView];
    
    //接着把后添加的两张图也添加到数组里面
    [self.imageArrays insertObject:[self.imageArrays firstObject] atIndex:0];
    [self.imageArrays addObject:[self.imageArrays lastObject]];
    
    //contentSize 这个时候，imageArrays 已经是添加多了2张
    [self.scrollView setContentSize:CGSizeMake(imageW*self.imageArrays.count, imageH)];
    
    //让scroller滚动到正常 的 1 位置
    self.scrollView.contentOffset = CGPointZero;
    [self.scrollView scrollRectToVisible:CGRectMake(imageW, 0, imageW, imageH) animated:NO];
    
    //addTimer
    [self addScrollTimer];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int page = offsetX / width;
    page --;//因为在初始化的时候，已经设定了让TA自动滚了一张图片的位置  4‘ 1 2 3 4 1’， 所以page 需要减1
    self.pageControl.currentPage = page;
    // NSLog(@"%f>%f",offsetX);
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    int page = offsetX / width;
    
    if(page == 0){
        
        self.pageControl.currentPage = [_imageArrays count]-2;
        [self.scrollView scrollRectToVisible:CGRectMake(width *( [_imageArrays count]-2),0,width,height) animated:NO]; // 如果滚动到了 4‘ 就需要重新滚动回正常的 4位置
        
    }else if (page == _imageArrays.count - 1){
        self.pageControl.currentPage = 1;
        [self.scrollView scrollRectToVisible:CGRectMake(width,0,width,height) animated:NO]; // 如果滚动到了 1’，就重新滚动回正常的1位置
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    int page = offsetX / width;
    
    if(page == 0){
      
         [self.scrollView scrollRectToVisible:CGRectMake(width *( [_imageArrays count]-2),0,width,height) animated:NO]; // 如果滚动到了 4‘ 就需要重新滚动回正常的 4位置
        
    }else if (page == _imageArrays.count - 1){
    
        [self.scrollView scrollRectToVisible:CGRectMake(width,0,width,height) animated:NO]; // 如果滚动到了 1’，就重新滚动回正常的1位置
    }
    
    //addTimer
    [self addScrollTimer];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self removeScrollTimer];
}

-(void)addScrollTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:1.3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)removeScrollTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)nextPage{
    
    int currentPage = (int)self.pageControl.currentPage;
    currentPage++;
    // NSLog(@"%d- %d",currentPage,self.imageArrays.count-2);
    //currentPage = currentPage >= (self.imageArrays.count -2) ? 0 : currentPage;
    NSLog(@"%d",currentPage);
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    CGRect frame = CGRectMake(width*(currentPage+1), 0, width, height);
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
@end
