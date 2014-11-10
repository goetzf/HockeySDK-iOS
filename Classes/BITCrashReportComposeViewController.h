//
//  BITCrashReportComposeViewController.h
//  HockeySDK
//
//  Created by Götz Fabian on 07/11/14.
//
//

#import <UIKit/UIKit.h>

@protocol BITCrashReportComposeViewControllerDelegate;

/**
 View controller allowing the user to add his name, e-mail and a problem description when sending a crash report.
 
 This view controller is created when the `reportMode` property of `BITCrashManager` is set to `BITCrashManagerReportModeComposeView`.
 */
@interface BITCrashReportComposeViewController : UITableViewController

/**
 Sets the `BITCrashReportComposeViewControllerDelegate` delegate.
 
 Used for notifying whether the crash report was sent or cancelled.
 */
@property(nonatomic, weak) id<BITCrashReportComposeViewControllerDelegate> delegate;

/**
 Prefills the name and email fields with the given strings.
 
 @param userName The user name to use for the corresponding text field
 @param userEmail The user e-mail address to use for the corresponding text field
 */
- (void)prepareWithUserName:(NSString *)userName userEmail:(NSString *)userEmail;

@end
