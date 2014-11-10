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



@interface BITCrashReportComposeViewController ()
{
  NSString *_userName;
  NSString *_userEmail;
}

@property (nonatomic) IBOutlet UILabel *headerLabel;

@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextField *emailTextField;

@property (nonatomic) IBOutlet UILabel *problemDescriptionPlaceholder;
@property (nonatomic) IBOutlet UITextView *problemDescriptionTextView;

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
  
  [self setUpUserFields];
}

- (void)prepareWithUserName:(NSString *)userName userEmail:(NSString *)userEmail
{
  _userName = userName;
  _userEmail = userEmail;
  
  if (self.isViewLoaded)
    [self setUpUserFields];
}

- (void)setUpUserFields
{
  self.nameTextField.text = _userName;
  self.emailTextField.text = _userEmail;
}

#pragma mark - Actions

- (IBAction)sendReport:(id)sender {
  // Create meta data
  BITCrashMetaData *metaData = [BITCrashMetaData new];
  metaData.userID = BITHockeyManager.sharedHockeyManager.userID;
  metaData.userName = self.nameTextField.text;
  metaData.userEmail = self.emailTextField.text;
  metaData.userDescription = self.problemDescriptionTextView.text;
  
  // Submit
  [self.delegate crashReportComposeViewController:self didComposeWithMetaData:metaData];
}


- (IBAction)dismissReport:(id)sender {
  [self.delegate crashReportComposeViewControllerDidCancel:self];
}


#pragma mark - Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {
  // Hide placeholder when text is entered
  self.problemDescriptionPlaceholder.hidden = (textView.text.length > 0);
}

@end