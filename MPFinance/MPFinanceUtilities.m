//
//  MPFinanceUtilities.m
//
//  Created by Michael Patzer on 6/29/13.
//
/* The MIT License (MIT)
 
 Copyright (c) 2013 Michael Patzer
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "MPFinanceUtilities.h"

#define kMaxRate 100000
#define kMinRate -99999.99
#define kAcceptableVariance 0.000000001

@implementation MPFinanceUtilities

#pragma mark - Inflation

double MPDeflate(double futureValue, double interestRatePerPeriod, double periods) {
    return futureValue / pow((1 + interestRatePerPeriod), periods);
}

double MPInflate(double presentValue, double interestRatePerPeriod, double periods) {
    return presentValue * pow((1 + interestRatePerPeriod), periods);
}

#pragma mark - Time Value of Money

double MPPeriodsFromYears(double years, double periodsPerYear) {
    return years * periodsPerYear;
}

double MPInterestRatePerPeriod(double annualInterestRate, double periodsPerYear) {
    return annualInterestRate / periodsPerYear;
}

double MPPaymentAnnuity(MPAnnuityType annuityType, double interestRatePerPeriod) {
    // Annuity type plays a more complicated role in the payment calculation
    switch (annuityType) {
        case MPAnnuityDue: return (1 + interestRatePerPeriod);
        default: return 1; // Ordinary annuity by default
    }
}

double MPPresentValue(double futureValue,
                      double payment,
                      double interestRatePerPeriod,
                      double periods,
                      MPAnnuityType annuityType) {
    // If the discount/interest rate is 0, the present value is just
    // the negative of (future value + all of the payments made)
    if (interestRatePerPeriod == 0) {
        return -(futureValue + (payment * periods));
    }
    else {
        return (-payment * (1 + interestRatePerPeriod * annuityType) * ((pow(1 + interestRatePerPeriod, periods) - 1) / interestRatePerPeriod) - futureValue) / pow(1 + interestRatePerPeriod, periods);
    }
}

double MPFutureValue(double presentValue,
                     double payment,
                     double interestRatePerPeriod,
                     double periods,
                     MPAnnuityType annuityType) {
    // If the discount/interest rate is 0, the future value is just
    // the negative of (present value + all of the payments made)
    if (interestRatePerPeriod == 0) {
        return -(presentValue + (payment * periods));
    }
    else {
        return (-presentValue * pow((1 + interestRatePerPeriod), periods)) - (payment * (1 + interestRatePerPeriod * annuityType) * ((pow((1 + interestRatePerPeriod), periods) - 1) / interestRatePerPeriod));
    }
}

double MPPayment(double presentValue,
                 double futureValue,
                 double interestRatePerPeriod,
                 double periods,
                 MPAnnuityType annuityType) {
    // If the discount/interest rate is 0, the payment is just
    // the difference between present and future value divided by the
    // number of periods payments were made
    if (interestRatePerPeriod == 0) {
        return (-futureValue - presentValue) / periods;
    }
    else {
        return (presentValue + ((presentValue + futureValue) / (pow(1 + interestRatePerPeriod, periods) - 1))) * (-interestRatePerPeriod / MPPaymentAnnuity(annuityType, interestRatePerPeriod));
    }
}

// TODO: Simplify and bulletproof this method. Improve variable names.
double MPInterestRate(double presentValue,
                      double futureValue,
                      double payment,
                      double periods,
                      MPAnnuityType annuityType) {
    double initialGuessInterestRate = 0.1; // Initial guess
	double thePV1, thePV2, theDeriv;
	double variance = 0.00001;
	double i = 1;
	double lastGuessInterestRate = initialGuessInterestRate;
    
	do {
        // Find the present value of the initial guess interest rate
		thePV1 = MPPresentValue(futureValue,
                                payment,
                                initialGuessInterestRate,
                                periods,
                                annuityType) - presentValue;
        
        
        theDeriv = ((MPPresentValue(futureValue,
                                    payment,
                                    (initialGuessInterestRate + variance),
                                    periods,
                                    annuityType) - presentValue) - thePV1) / variance;
		thePV2 = thePV1;
		lastGuessInterestRate = initialGuessInterestRate;
		initialGuessInterestRate = initialGuessInterestRate - thePV1 / theDeriv;
        
        // Too many tries
		if (i > 200) {
			return 0;
		}
		i++;
		if (thePV2 < 0) thePV2 *= -1;
	} while (thePV2 > 0.0001);
    
	return (lastGuessInterestRate * 100); // Return as percentage
}

double MPPeriods(double presentValue,
                 double futureValue,
                 double payment,
                 double interestRatePerPeriod,
                 MPAnnuityType annuityType) {
    // If the discount/interest rate is 0, the payment is just
    // the difference between present and future value divided by the
    // amount of the fixed payment
    if (interestRatePerPeriod == 0) {
        return (-futureValue - presentValue) / payment;
    }
    else {
        double paymentAnnuityType = MPPaymentAnnuity(annuityType, interestRatePerPeriod);
        return (log10((((payment * paymentAnnuityType) / interestRatePerPeriod) - futureValue) / (((payment * paymentAnnuityType) / interestRatePerPeriod) + presentValue)) / (log10(1 + interestRatePerPeriod)));
    }
}

#pragma mark - Interest Rates

// Convert Annual Percentage Rate to Effective Annual Rate
double MPAPRToEAR(double APR, double period) {
    return (pow((1 + (APR / period)), period) - 1);
}

// Convert Effective Annual Rate to Annual Percentage Rate
double MPEARToAPR(double EAR, double period) {
    return ((pow((EAR + 1), (1 / period)) - 1) * period);
}

#pragma mark - Valuation

//TODO: There is a better way to do this, especially given the TVM equations above.
double MPIRR(NSArray *cashflow) {
    // Try an interest rate within the constraints of a min and max
    double minRate = kMinRate;
    double maxRate = kMaxRate;
    double trialRate = 0;
    double acceptableVariance = kAcceptableVariance;
    double netPresentValue = 0;
    
    // Binary search for the correct interest rate
    // The sign (+/-) of the variance determines the direction on the binary tree to search: left or right
    while (minRate < (maxRate - acceptableVariance)) {
        trialRate = (minRate + maxRate) / 2;
        
        netPresentValue = MPNPV(cashflow, trialRate);
        
        if (netPresentValue < -acceptableVariance) {
            maxRate = trialRate;
        }
        else if (netPresentValue > acceptableVariance) {
            minRate = trialRate;
        }
    }
    
    return trialRate;
}

double MPNPV(NSArray *cashflow, double discountRate) {
    // The initial investment.
    double initialCashFlow = [cashflow[0] doubleValue];
    double sumOfPresentValues = 0;
    
    // Only cashflows beyond period 0 can be discounted.
    if ([cashflow count] < 1) return initialCashFlow;
    else {
        // Discount each cashflow to its present value.
        for (int i = 1; i < [cashflow count]; i++) {
            double currentPeriodCashFlow = [cashflow[i] doubleValue];
            double discountedCurrentPeriodCashFlow = currentPeriodCashFlow / pow((1 + discountRate), i);
            
            // Add the discounted cashflows
            sumOfPresentValues += discountedCurrentPeriodCashFlow;
        }
    }
    
    // Return NPV: Net Present Value
    return initialCashFlow + sumOfPresentValues;
}

@end
