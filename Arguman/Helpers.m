//
//  Helpers.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 08/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "Helpers.h"

static NSDateFormatter *dateFormatter;
static NSDateFormatter *dateFormatter1;


NSDate *formatDateFromString(NSString *dateString)
{
    if (!dateString) {
        return nil;
    }
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:s.SSS"];
    }
    return [dateFormatter dateFromString:dateString];
}

NSDate *formatDate1FromString(NSString *dateString)
{
    if (!dateString) {
        return nil;
    }
    if (!dateFormatter1) {
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd-MM-yyyy HH:mm"];
    }
    return [dateFormatter1 dateFromString:dateString];
}

NSURL *formatURLFromString(NSString *urlString)
{
    if (!urlString) {
        return nil;
    }
    return [NSURL URLWithString:urlString];
}