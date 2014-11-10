//
//  BITCrashReportComposeViewControllerDelegate.h
//  HockeySDK
//
//  Created by Götz Fabian on 07/11/14.
//
//

#import <Foundation/Foundation.h>

@class BITCrashMetaData, BITCrashReportComposeViewController;


/** 
 Delegate for notifying about changes to the status of the compose view controller.
 */
@protocol BITCrashReportComposeViewControllerDelegate <NSObject>

/**
 Notifies the delegate that the composing the crash report was cancelled.
 
 @param composeViewController The view controller used for composing the report.
 */
- (void)crashReportComposeViewControllerDidCancel:(BITCrashReportComposeViewController *)composeViewController;

/**
 Notifies the delegate that the crash report should be send with the given meta data.

 @param composeViewController The view controller used for composing the report.
 @param metaData The meta data to attach to the report.
 */
- (void)crashReportComposeViewController:(BITCrashReportComposeViewController *)composeViewController didComposeWithMetaData:(BITCrashMetaData *)metaData;

@end
