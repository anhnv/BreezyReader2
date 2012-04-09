//
//  BRMainScreenController.h
//  BreezyReader2
//
//  Created by 金 津 on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBaseController.h"
#import "InfinityScrollView.h"
#import "SideMenuController.h"
#import "BRFeedAndArticlesSearchController.h"
#import "SubOverviewController.h"

@interface BRMainScreenController : BRBaseController <InfinityScrollViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) InfinityScrollView* infinityScroll;
@property (nonatomic, retain) NSArray* labelViewControllers;
@property (nonatomic, retain) IBOutlet SideMenuController* sideMenuController;
@property (nonatomic, retain) IBOutlet BRFeedAndArticlesSearchController* searchController;
@property (nonatomic, retain) SubOverviewController* subOverrviewController;

@end