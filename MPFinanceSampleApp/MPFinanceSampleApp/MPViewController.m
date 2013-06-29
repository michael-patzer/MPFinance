//
//  MPViewController.m
//  MPFinanceSampleApp
//
//  Created by Michael Patzer on 6/29/13.
//  Copyright (c) 2013 Michael Patzer. All rights reserved.
//

#import "MPViewController.h"
#import "MPFinanceUtilities.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inflateButtonTapped:(id)sender {
    double presentValue = [self.initialAmountTextField.text doubleValue];
    // We divide by 100 because the user is unlikely to enter the interest rate as a decimal
    double interestRatePerPeriod = [self.annualInterestRateTextField.text doubleValue] / 100;
    double periods = [self.yearsTextField.text doubleValue];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%.2f", MPInflate(presentValue, interestRatePerPeriod, periods)];
}

- (IBAction)deflateButtonTapped:(id)sender {
    double presentValue = [self.initialAmountTextField.text doubleValue];
    // We divide by 100 because the user is unlikely to enter the interest rate as a decimal
    double interestRatePerPeriod = [self.annualInterestRateTextField.text doubleValue] / 100;
    double periods = [self.yearsTextField.text doubleValue];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%.2f", MPDeflate(presentValue, interestRatePerPeriod, periods)];
}

@end
