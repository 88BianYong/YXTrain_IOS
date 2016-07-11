//
//  YXActionSheet.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YXActionSheetBlock)(void);

@interface YXActionSheet : UIActionSheet
/** Creates and returns a new action sheet with only a title button.
 
 @warning You should add a cancel button manually by
 [addCancelButtonWithTitle:action:] at last.
 
 @param title The header of the action sheet.
 @return A newly created action sheet.
 */
+ (id)actionSheetWithTitle:(NSString *)title;

///-----------------------------------
/// @name Adding buttons
///-----------------------------------

/** Add a new button with an associated code block.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (void)addButtonWithTitle:(NSString *)title action:(YXActionSheetBlock)block;


/** Set the destructive (red) button with an associated code block.
 
 @warning Because buttons cannot be removed from an action sheet,
 be aware that the effects of calling this method are cumulative.
 Previously added destructive buttons will become normal buttons.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (void)addDestructiveButtonWithTitle:(NSString *)title action:(YXActionSheetBlock)block;


/** Set the cancel button with an associated code block.
 
 @warning Because buttons cannot be removed from an action sheet,
 be aware that the effects of calling this method are cumulative.
 Previously added cancel buttons will become normal buttons.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (void)addCancelButtonWithTitle:(NSString *)title action:(YXActionSheetBlock)block;

@end
