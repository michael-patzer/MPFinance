//
//  MPViewController.h
//  MPFinanceSampleApp
//
//  Created by Michael Patzer on 6/29/13.
//  Copyright (c) 2013 Michael Patzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *initialAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *annualInterestRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearsTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)inflateButtonTapped:(id)sender;
- (IBAction)deflateButtonTapped:(id)sender;

@end
