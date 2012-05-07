//
//  BRFeedActionMenuViewController.h
//  BreezyReader2
//
//  Created by Jin Jin on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRActionMenuViewController.h"

typedef enum{
    BRFeedActoinMenuStatusShowAllArticles,
    BRFeedActoinMenuStatusUnreadOnly
} BRFeedActoinMenuStatus;

@interface BRFeedActionMenuViewController : BRActionMenuViewController

@property (nonatomic, retain) IBOutlet UIButton* markAllAsReadButton;
@property (nonatomic, retain) IBOutlet UIButton* unreadOnlyButton;
@property (nonatomic, retain) IBOutlet UIButton* showAllButton;

-(IBAction)showUnreadOnlyButtonClicked:(id)sender;
-(IBAction)showAllArticlesButtonClicked:(id)sender;
-(IBAction)markAllAsReadButtonClicked:(id)sender;

-(void)setActionStatus:(BRFeedActoinMenuStatus)status;

@end
