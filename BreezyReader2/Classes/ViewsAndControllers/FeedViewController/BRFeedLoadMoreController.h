//
//  BRFeedLoadMoreController.h
//  BreezyReader2
//
//  Created by 金 津 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRFeedLoadMoreController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;

-(void)loadMore;
-(void)stopLoadingWithMore:(BOOL)more;

@end