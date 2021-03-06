//
//  BRChooseBackgroundImage.m
//  BreezyReader2
//
//  Created by 金 津 on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BRChooseBackgroundImage.h"
#import "BRUserPreferenceDefine.h"
#import "BRViewControllerNotification.h"
#import "BaseActivityLabel.h"

#define vImageName1 @"background1.jpg"
#define vImageName2 @"background2.jpg"
#define vImageName3 @"background3.jpg"

@implementation BRChooseBackgroundImage

@synthesize image1Button = _image1Button, image2Button = _image2Button, image3Button = _image3Button, userImageButton = _userImageButton;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(CGFloat)heightForCustomView{
    return 116.0f;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.image1Button.highlighted = NO;
    self.image2Button.highlighted = NO;
    self.image3Button.highlighted = NO;
    self.userImageButton.highlighted = NO;
    NSString* backgroundImageName = [BRUserPreferenceDefine backgroundImageName];
    if ([backgroundImageName isEqualToString:vImageName1]){
        self.image1Button.highlighted = YES;
    }else if ([backgroundImageName isEqualToString:vImageName2]){
        self.image2Button.highlighted = YES;
    }else if ([backgroundImageName isEqualToString:vImageName3]){
        self.image3Button.highlighted = YES;
    }else {
        self.userImageButton.highlighted = YES;
    }
}

-(void)imageButtonClicked:(id)sender{
    NSString* imageName = nil;
    if (sender == self.image1Button){
        imageName = vImageName1;
    }else if (sender == self.image2Button){
        imageName = vImageName2;
    }else if (sender == self.image3Button){
        imageName = vImageName3;
    }
    
    if (imageName){
        BaseActivityLabel* activityLabel = [BaseActivityLabel loadFromBundle];
        
        activityLabel.message = NSLocalizedString(@"message_settingbackgroundimage", nil);
        [activityLabel show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [BRUserPreferenceDefine setDefaultBackgroundImage:[UIImage imageNamed:imageName] withName:imageName];
            dispatch_async(dispatch_get_main_queue(), ^{
                activityLabel.message = NSLocalizedString(@"title_done", nil);
                [activityLabel setFinished:YES];
                [self setNeedsLayout];
            });
        });
        
    }
}

-(void)chooseImageFromAlbum:(id)sender{
    //selected from album
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAITON_SETTING_PICKIMAGEFORBACKGROUND object:nil];
}

@end
