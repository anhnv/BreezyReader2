//
//  BRArticleScrollViewController.m
//  BreezyReader2
//
//  Created by 金 津 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BRArticleScrollViewController.h"
#import "BRArticleDetailViewController.h"
#import "UIViewController+BRAddtion.h"
#import "GoogleReaderClient.h"
#import "JJSingleWebController.h"
#import "BRADManager.h"

@interface BRArticleScrollViewController ()

@property (nonatomic, retain) NSArray* articleDetailControllers;
@property (nonatomic, retain) NSMutableSet* clients;

@property (nonatomic, retain) UIView* adView;

@end

@implementation BRArticleScrollViewController

@synthesize scrollView = _scrollView;
@synthesize index = _index;
@synthesize feed = _feed;
@synthesize backButton = _backButton;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize articleDetailControllers = _articleDetailControllers;
@synthesize clients = _clients;
@synthesize adView = _adView;

-(void)dealloc{
    self.scrollView = nil;
    self.feed = nil;
    self.backButton = nil;
    self.bottomToolBar = nil;
    self.articleDetailControllers = nil;
    self.clients = nil;
    self.adView = nil;
    [super dealloc];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.clients = [NSMutableSet set];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadControllers];
    self.scrollView.datasource = self;
    self.scrollView.scrollDelegate = self;
    self.scrollView.pageIndex = self.index;
    [self.scrollView reloadData];
    
    self.adView = [[BRADManager sharedManager] adView];
    if (self.adView){
        CGRect frame = self.adView.frame;
        frame.origin.x = 0;
        frame.origin.y = self.view.bounds.size.height-self.bottomToolBar.frame.size.height-frame.size.height;
        self.adView.frame = frame;
        [self.view addSubview:self.adView];
        [self.view bringSubviewToFront:self.bottomToolBar];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.bottomToolBar = nil;
    self.articleDetailControllers = nil;
    self.adView = nil;
}

-(void)viewWillLayoutSubviews{
    CGRect frame = self.bottomToolBar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.bottomToolBar.frame = frame;
    
    frame = self.scrollView.frame;
    frame.size.height = self.view.frame.size.height - self.bottomToolBar.frame.size.height;
    self.scrollView.frame = frame;
    
    [self.view bringSubviewToFront:self.bottomToolBar];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.adView performSelector:@selector(stopAdRequest)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.adView performSelector:@selector(resumeAdRequest)];
}

-(void)loadControllers{
    NSMutableArray* controllers = [NSMutableArray array];
    for (GRItem* item in self.feed.items){
        BRArticleDetailViewController* articleDetail = [[[BRArticleDetailViewController alloc] initWithItem:item] autorelease];
        [controllers addObject:articleDetail];
        [self addChildViewController:articleDetail];
    }
    
    self.articleDetailControllers = controllers;
}

-(void)markAsReadFinished:(GoogleReaderClient*)client{
    [self.clients removeObject:client];
}

#pragma mark - action
-(IBAction)back:(id)sender{
    [[self topContainer] slideOutViewController];
}

-(IBAction)viewInSafari:(id)sender{
    NSInteger index = [self.scrollView currentIndex];
    GRItem* item = [self.feed.items objectAtIndex:index];
    JJSingleWebController* webController = [[[JJSingleWebController alloc] initWithTheNibOfSameName] autorelease];
    webController.URL = [NSURL URLWithString:item.alternateLink];
    
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:webController] autorelease];
    [[self topContainer] presentViewController:nav animated:YES completion:NULL];
}

-(IBAction)scrollCurrentPageToTop:(id)sender{
    NSInteger index = [self.scrollView currentIndex];
    [[self.articleDetailControllers objectAtIndex:index] performSelector:@selector(scrollToTop)];
}

#pragma mark - JJPageScrollView data source

-(NSUInteger)numberOfPagesInScrollView:(JJPageScrollView*)scrollView{
    return [self.feed.items count];
}

-(UIView*)scrollView:(JJPageScrollView*)scrollView pageAtIndex:(NSInteger)index{
    UIViewController* controller = [self.articleDetailControllers objectAtIndex:index];
    return controller.view;
}

-(CGSize)scrollView:(JJPageScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)index{
    return self.scrollView.bounds.size;
}

#pragma mark - JJPageScrollView delegate

-(void)scrollView:(JJPageScrollView*)scrollView didScrollToPageAtIndex:(NSInteger)index{
    GRItem* item = [self.feed.items objectAtIndex:index];
    if (item.isReaded == NO){
        GoogleReaderClient* client = [GoogleReaderClient clientWithDelegate:self action:@selector(markAsReadFinished:)];
        [self.clients addObject:client];
        [client markArticleAsRead:item.ID];
    }
}

-(void)scrollViewWillBeginDragging:(JJPageScrollView *)scrollView{
    
}

-(void)scrollViewDidRemovePageAtIndex:(NSInteger)index{
    UIViewController* controller = [self.articleDetailControllers objectAtIndex:index];
    [controller viewWillUnload];
    controller.view = nil;
    [controller viewDidUnload];
}

@end
