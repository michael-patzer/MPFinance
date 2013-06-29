//
//  MPFinanceUtilities.h
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

#import <Foundation/Foundation.h>

typedef enum {
    MPAnnuityOrdinary = 0,
    MPAnnuityDue = 1
} MPAnnuityType;

@interface MPFinanceUtilities : NSObject

// Inflation
double MPDeflate(double futureValue, double interestRatePerPeriod, double periods);
double MPInflate(double presentValue, double interestRatePerPeriod, double periods);

// Time Value of Money
double MPPeriodsFromYears(double years, double periodsPerYear);
double MPInterestRatePerPeriod(double annualInterestRate, double periodsPerYear);
double MPPaymentAnnuity(MPAnnuityType annuityType, double interestRatePerPeriod);

double MPPresentValue(double futureValue,
                      double payment,
                      double interestRatePerPeriod,
                      double periods,
                      MPAnnuityType annuityType);

double MPFutureValue(double presentValue,
                     double payment,
                     double interestRatePerPeriod,
                     double periods,
                     MPAnnuityType annuityType);

double MPPayment(double presentValue,
                 double futureValue,
                 double interestRatePerPeriod,
                 double periods,
                 MPAnnuityType annuityType);

double MPInterestRate(double presentValue,
                      double futureValue,
                      double payment,
                      double periods,
                      MPAnnuityType annuityType);

double MPPeriods(double presentValue,
                 double futureValue,
                 double payment,
                 double interestRatePerPeriod,
                 MPAnnuityType annuityType);

// Interest Rates
double MPAPRToEAR(double APR, double period);
double MPEARToAPR(double EAR, double period);

// Valuation
double MPIRR(NSArray *cashflow);
double MPNPV(NSArray *cashflow, double discountRate);

@end
