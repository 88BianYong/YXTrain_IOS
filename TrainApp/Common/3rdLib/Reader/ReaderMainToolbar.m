//
//	ReaderMainToolbar.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"

#import <MessageUI/MessageUI.h>
//#import "UIButton+YXButton.h"

@implementation ReaderMainToolbar
{
    UIButton *likeButton;
    
    UIImage *markImageN;
    UIImage *markImageY;
    
    UIButton *_favorButton;
}

#pragma mark - Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f

#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define BUTTON_FONT_SIZE 15.0f
#define TEXT_BUTTON_PADDING 24.0f

#define ICON_BUTTON_WIDTH 40.0f

#define TITLE_FONT_SIZE 17.f
#define TITLE_HEIGHT 28.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - ReaderMainToolbar instance methods

- (void)setRightFavorButton:(UIButton *)rightFavorButton{
    _rightFavorButton = rightFavorButton;
    if (rightFavorButton) {
        rightFavorButton.frame = _favorButton.frame;
        [self addSubview:rightFavorButton];
        CGRect rect = self.nameLabel.frame;
        rect.size.width -= (_favorButton.frame.size.width + BUTTON_X);
        self.nameLabel.frame = rect;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame document:nil];
}

- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)document
{
    assert(document != nil); // Must have a valid ReaderDocument
    
    if ((self = [super initWithFrame:frame]))
    {
        CGFloat viewWidth = self.bounds.size.width; // Toolbar view width
        
        //BOOL largeDevice = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
        
        const CGFloat buttonSpacing = BUTTON_SPACE; const CGFloat iconButtonWidth = ICON_BUTTON_WIDTH;
        
        CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));
        
        CGFloat leftButtonX = BUTTON_X; // Left-side button start X position
        
#if (READER_STANDALONE == FALSE) // Option
        
        UIFont *doneButtonFont = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
        NSString *doneButtonText = NSLocalizedString(@"返回", @"button");
        CGSize doneButtonSize = [doneButtonText sizeWithAttributes:@{NSFontAttributeName:doneButtonFont}];
        CGFloat doneButtonWidth = (doneButtonSize.width + TEXT_BUTTON_PADDING);
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(leftButtonX, BUTTON_Y, doneButtonWidth, BUTTON_HEIGHT);
//        [doneButton yx_setTitleColor:[UIColor whiteColor] image:[UIImage imageNamed:@"icon_back"]];
        [doneButton setTitle:doneButtonText forState:UIControlStateNormal];
        doneButton.titleLabel.font = doneButtonFont;
        [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        doneButton.autoresizingMask = UIViewAutoresizingNone;
        doneButton.exclusiveTouch = YES;
        
        [self addSubview:doneButton]; leftButtonX += (doneButtonWidth + buttonSpacing);
        
        titleX += (doneButtonWidth + buttonSpacing); titleWidth -= (doneButtonWidth + buttonSpacing);
        
#endif // end of READER_STANDALONE Option
        
        CGFloat rightButtonX = viewWidth; // Right-side buttons start X position
        
        rightButtonX -= (iconButtonWidth + buttonSpacing); // Position
        UIButton *favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favouriteButton.frame = CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
        [favouriteButton setImage:[UIImage imageNamed:@"icon_favourite_normal"] forState:UIControlStateNormal];
        [favouriteButton addTarget:self action:@selector(favouriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        favouriteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        favouriteButton.exclusiveTouch = YES;
        _favorButton = favouriteButton;
        [self addSubview:favouriteButton];
        
        _favorButton.hidden = YES;
        
        //if (largeDevice == YES) // Show document filename in toolbar
        {
            CGRect titleRect = CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
            
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.minimumScaleFactor = 0.75f;
            titleLabel.text = [document.fileName stringByDeletingPathExtension];
            [self addSubview:titleLabel];
            self.nameLabel = titleLabel;
        }
    }
    
    return self;
}


- (void)hideToolbar
{
}

- (void)showToolbar
{
}

- (void)setBookmarkState:(BOOL)state {
}

#pragma mark - UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self doneButton:button];
}

- (void)favouriteButtonTapped:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"icon_favourite_selected"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"icon_favourite_normal"] forState:UIControlStateNormal];
    }
    [delegate tappedInToolbar:self favouriteButton:button];
}

- (void)setBIsFavor:(BOOL)bIsFavor {
    _bIsFavor = bIsFavor;
    _favorButton.selected = bIsFavor;
}

- (void)setBIsGuopei:(BOOL)bIsGuopei {
    _bIsGuopei = bIsGuopei;
    if (bIsGuopei) {
        _favorButton.hidden = YES;
    } else {
        _favorButton.hidden = NO;
    }
}

@end
