//
//  BITCrashReportComposeViewController.m
//  HockeySDK
//
//  Created by Götz Fabian on 07/11/14.
//
//

#import "BITCrashReportComposeViewController.h"

#import "BITCrashMetaData.h"
#import "BITCrashReportComposeViewControllerDelegate.h"
#import "BITHockeyHelper.h"
#import "BITHockeyManager.h"
#import "HockeySDKPrivate.h"

#import "BITDeviceHardware.h"



@interface BITCrashReportComposeViewController ()

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userEmail;

@property (nonatomic) IBOutlet UILabel *headerLabel;

@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextField *emailTextField;

@property (nonatomic) IBOutlet UILabel *problemDescriptionPlaceholder;
@property (nonatomic) IBOutlet UITextView *problemDescriptionTextView;

@property (nonatomic) IBOutlet UILabel *deviceInfoLabel;

@end

@implementation BITCrashReportComposeViewController

- (instancetype)init {
  return [[UIStoryboard storyboardWithName:NSStringFromClass(self.class) bundle:BITHockeyBundle()] instantiateInitialViewController];
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Set description string, shown at header of table view
  NSString *appName = bit_appName(BITHockeyLocalizedString(@"HockeyCrashReportAppNamePlaceholder"));
  NSString *companyName = BITHockeyManager.sharedHockeyManager.companyName;
  if (companyName.length)
    self.headerLabel.text = [NSString stringWithFormat:BITHockeyLocalizedString(@"HockeyCrashReportDescription"), appName, companyName];
  else
    self.headerLabel.text = [NSString stringWithFormat:BITHockeyLocalizedString(@"HockeyCrashReportShortDescription"), appName];
  
  self.deviceInfoLabel.text = [NSString stringWithFormat:BITHockeyLocalizedString(@"HockeyCrashReportDeviceInfo"), BITDeviceHardware.platformString, NSProcessInfo.processInfo.operatingSystemVersionString];
  
  [self setUpUserFields];
  
  if (self.nameTextField.text.length == 0)
    [self.nameTextField becomeFirstResponder];
  else if (self.emailTextField.text.length == 0)
    [self.emailTextField becomeFirstResponder];
  else
    [self.problemDescriptionTextView becomeFirstResponder];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  // Check if header view height has changed or not, then update as needed
  if (self.tableView.tableHeaderView && [self updateHeaderViewHeightIfNeeded]) {
    UIView *view = self.tableView.tableHeaderView;
    
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = view;
  }
}

- (BOOL)updateHeaderViewHeightIfNeeded
{
  UIView *headerView = self.tableView.tableHeaderView;
  
  // Calculate required height of header view
  CGRect frame = headerView.frame;
  CGSize size = [headerView systemLayoutSizeFittingSize: CGSizeMake(self.tableView.frame.size.width, 0) withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
  frame.size.height = size.height;
  
  // Update frame if needed
  if (!CGRectEqualToRect(headerView.frame, frame)) {
    headerView.frame = frame;
    return YES;
  } else {
    return NO;
  }
}

- (void)prepareWithUserName:(NSString *)userName userEmail:(NSString *)userEmail
{
  self.userName = userName;
  self.userEmail = userEmail;
  
  if (self.isViewLoaded)
    [self setUpUserFields];
}

- (void)setUpUserFields
{
  self.nameTextField.text = self.userName;
  self.emailTextField.text = self.userEmail;
}

#pragma mark - Actions

- (IBAction)sendReport:(__unused id)sender {
  // Create meta data
  BITCrashMetaData *metaData = [BITCrashMetaData new];
  metaData.userID = BITHockeyManager.sharedHockeyManager.userID;
  metaData.userName = self.nameTextField.text;
  metaData.userEmail = self.emailTextField.text;
  metaData.userProvidedDescription = self.problemDescriptionTextView.text;
  
  // Submit
  [self.delegate crashReportComposeViewController:self didComposeWithMetaData:metaData];
}

- (IBAction)dismissReport:(__unused id)sender {
  [self.delegate crashReportComposeViewControllerDidCancel:self];
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.nameTextField)
    [self.emailTextField becomeFirstResponder];
  else if (textField == self.emailTextField)
    [self.problemDescriptionTextView becomeFirstResponder];

  return NO;
}


#pragma mark - Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {
  // Hide placeholder when text is entered
  self.problemDescriptionPlaceholder.hidden = (textView.text.length > 0);
}

@end
