//
//  BRFeedConfigViewController.m
//  BreezyReader2
//
//  Created by 金 津 on 12-4-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UIViewController+BRAddtion.h"
#import "BRFeedConfigViewController.h"
#import "BRFeedControlViewSource.h"
#import "BRRelatedFeedViewSource.h"
#import "BRFeedDetailViewSource.h"
#import "BRFeedLabelsViewSource.h"
#import "BRViewControllerNotification.h"
#import "BRRelatedFeedViewSource.h"
#import "BRFeedViewController.h"

@interface BRFeedConfigViewController ()

@end

@implementation BRFeedConfigViewController

@synthesize subscription = _subscription;

@synthesize tableView = _tableView;
@synthesize feedOpertaionControllers = _feedOpertaionControllers;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.feedOpertaionControllers = nil;
    self.subscription = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self registerNotifications];
    }
    return self;
}

-(void)registerNotifications{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(unsubscribeFeed:) name:NOTIFICATION_CONFIG_UNSUBSCRIBEFEED object:nil];
    [nc addObserver:self selector:@selector(renameFeed:) name:NOTIFICATION_CONFIG_RENAMEFEED object:nil];
    [nc addObserver:self selector:@selector(addTagToFeed:) name:NOTIFICATION_CONFIG_ADDTAG object:nil];
    [nc addObserver:self selector:@selector(removeTagFromFeed:) name:NOTIFICATION_CONFIG_REMOVETAG object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feedOpertaionControllers = [NSMutableArray array];
    //add detail view controller
    BRFeedDetailViewSource* detailController = [[[BRFeedDetailViewSource alloc] init] autorelease];
    detailController.subscription = self.subscription;
    detailController.tableController = self;
    BRFeedLabelsViewSource* labelsController = [[[BRFeedLabelsViewSource alloc] init] autorelease];
    labelsController.subscription = self.subscription;
    labelsController.tableController = self;
    BRFeedControlViewSource* controlsController = [[[BRFeedControlViewSource alloc] init] autorelease];
    controlsController.subscription = self.subscription;
    controlsController.tableController = self;
    BRRelatedFeedViewSource* relatedFeedController = [[[BRRelatedFeedViewSource alloc] init] autorelease];
    relatedFeedController.subscription = self.subscription;
    relatedFeedController.tableController = self;
    [self.feedOpertaionControllers addObject:detailController];
    if ([GoogleReaderClient containsSubscription:self.subscription.ID] == NO){
        [self.feedOpertaionControllers addObject:controlsController];        
    }
    [self.feedOpertaionControllers addObject:relatedFeedController];
    if ([GoogleReaderClient containsSubscription:self.subscription.ID] == YES){
        [self.feedOpertaionControllers addObject:labelsController];
    }
    if ([GoogleReaderClient containsSubscription:self.subscription.ID] == YES){
        [self.feedOpertaionControllers addObject:controlsController];        
    }
    //add labels view controller
    //add related feed view controller
    //add feed operation view controller
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.feedOpertaionControllers = nil;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.feedOpertaionControllers makeObjectsPerformSelector:@selector(viewDidDisappear)];
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:indexPath.section];
    [controller didSelectRowAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [controller
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:indexPath.section];
    return [controller heightOfRowAtIndex:indexPath.row];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:section];
    return controller.sectionTitle;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:section];
    return [controller sectionView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:section];
    return [controller heightForHeader];
}

#pragma mark - table view datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:section];
    return [controller numberOfRowsInSection];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.feedOpertaionControllers count];
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BRFeedConfigBase* controller = [self.feedOpertaionControllers objectAtIndex:indexPath.section];
    return [controller tableView:tableView cellForRow:indexPath.row];
}

-(void)reloadSectionFromSource:(BRFeedConfigBase*)source{
    NSInteger index = [self.feedOpertaionControllers indexOfObject:source];
    if (index != NSNotFound){
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)reloadRowsFromSource:(BRFeedConfigBase*)source row:(NSInteger)row animated:(BOOL)animated{
    NSInteger section = [self.feedOpertaionControllers indexOfObject:source];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    UITableViewRowAnimation animation = UITableViewRowAnimationNone;
    if(animated){
        animation = UITableViewRowAnimationAutomatic;
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
}

#pragma mark - notification callback
-(void)unsubscribeFeed:(NSNotification*)notification{

}

-(void)renameFeed:(NSNotification*)notification{

}

-(void)addTagToFeed:(NSNotification*)notification{

}

-(void)removeTagFromFeed:(NSNotification*)notification{

}

#pragma mark - table callback action
-(void)showSubscription:(GRSubscription*)subscription{
    BRFeedViewController* feedController = [[[BRFeedViewController alloc] initWithTheNibOfSameName] autorelease];
    feedController.subscription = subscription;
    [[self topContainer] replaceTopByController:feedController animated:YES];
}

-(void)showAddNewTagView{
    
}
-(void)addNewTag{
    
}
-(void)addTag:(NSString*)addID removeTag:(NSString*)removeID{
    
}
-(void)unsubscribeButtonClicked{
    
}
-(void)subscribeButtonClicked{
    
}
-(void)renameButtonClicked{
    
}

@end
