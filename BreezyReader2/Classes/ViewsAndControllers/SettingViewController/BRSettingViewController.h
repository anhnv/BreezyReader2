//
//  BRSettingViewController.h
//  BreezyReader2
//
//  Created by 金 津 on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRSettingCellActions.h"
#import "JJPickerView.h"

@interface BRSettingViewController : UITableViewController <BRSettingCellActions, UIPickerViewDelegate, UIPickerViewDataSource, JJViewDelegate>



@end
