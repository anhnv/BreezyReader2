//
//  JJImageScrollController.m
//  BreezyReader2
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JJImageScrollController.h"
#import "JJImageZoomView.h"

@interface JJImageScrollController (){
    BOOL _outletHidden;
}

@property (nonatomic, retain) UITapGestureRecognizer* singleTap;

@end

@implementation JJImageScrollController


@synthesize scrollView = _scrollView;
@synthesize imageList = _imageList;
@synthesize index = _index;
@synthesize singleTap = _singleTap;

-(void)dealloc{
    self.scrollView = nil;
    self.imageList = nil;
    self.singleTap = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [[[JJPageScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.datasource = self;
    self.scrollView.scrollDelegate = self;
    self.singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singelTapAction:)] autorelease];
    [self.scrollView addGestureRecognizer:self.singleTap];
    [self.view addSubview:self.scrollView];
    self.scrollView.pageIndex = self.index;
    [self.scrollView reloadData];    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIImage*)imageAtIndex:(NSInteger)index{
    JJImageZoomView* imageView = (JJImageZoomView*)[self.scrollView pageAtIndex:index];
    return imageView.loadedImage;
}

-(void)singleTagAction:(UITapGestureRecognizer*)singleTap{
    
}

#pragma mark - image scroll view delegate method
-(void)scrollView:(JJPageScrollView *)scrollView didScrollToPageAtIndex:(NSInteger)index{

}

-(void)scrollViewWillBeginDragging:(JJPageScrollView *)scrollView{
    
}

#pragma mark - image scroll view data source
-(NSUInteger)numberOfPagesInScrollView:(JJPageScrollView*)scrollView{
    return [self.imageList count];
}

-(UIView*)scrollView:(JJPageScrollView*)scrollView pageAtIndex:(NSInteger)index{
    JJImageZoomView* imageView = [[JJImageZoomView alloc] initWithFrame:self.view.bounds];
    for (UIGestureRecognizer* gesutre in imageView.gestureRecognizers){
        [self.singleTap requireGestureRecognizerToFail:gesutre];
    }
    [imageView setImageURL:[self.imageList objectAtIndex:index]];
    return [imageView autorelease];
}

-(CGSize)scrollView:(JJPageScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)index{
    return self.view.bounds.size;
}

-(void)setImageList:(NSArray *)imageList startIndex:(NSInteger)index{
    self.imageList = imageList;
    self.index = index;
}

@end
