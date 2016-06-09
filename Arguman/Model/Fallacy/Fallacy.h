//
//  Fallacy.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 08/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Premise.h"
#import "Contention.h"


@interface Fallacy : NSObject

@property (copy) NSString *reason;
@property (copy) NSString *fallacyType;
@property (copy) NSString *language;

@property (strong) Premise *premise;
@property (strong) Contention *contention;

+ (NSArray *)allFallacies;

- (instancetype)initWithJSONResponse:(NSDictionary *)response;

@end


/*
 ["Begging The Question,", "Kısır Döngü Safsatası"],
 ["Irrelevant Conclusion", "Alakasız Sonuç Safsatası"],
 ["Fallacy of Irrelevant Purpose", "Alakasız Amaç Safsatası"],

 ["Fallacy of Red Herring", "Konuyu Saptırma Safsatası"],
 ["Argument Against the Man", "Adam Karalama Safsatası"],

 ["Poisoning The Well", "Dolduruşa Getirme Safsatası"],
 ["Fallacy Of The Beard", "Devede Kulak Safsatası"],
 ["Fallacy of Slippery Slope", "Felaket Tellallığı Safsatası"],

 ["Fallacy of False Cause", "Yanlış Sebep Safsatası"],
 ["Fallacy of “Previous This”", "Öncesinde Safsatası"],
 ["Joint Effect", "Müşterek Etki"],
 ["Wrong Direction", "Yanlış Yön Safsatası"],
 ["False Analogy", "Yanlış Benzetme Safsatası"],
 ["Slothful Induction", "Yok Sayma Safsatası"],
 ["Appeal to Belief", "İnanca Başvurma Safsatası"],
 ["Pragmatic Fallacy", "Faydacı Safsata"],
 ["Fallacy Of “Is” To “Ought”", "Dayatma Safsatası"],
 ["Argument From Force", "Tehdit Safsatası"],
 ["Argument To Pity", "Duygu Sömürüsü"],
 ["Prejudicial Language", "Önyargılı Dil Safsatası"],
 ["Fallacy Of Special Pleading", "Mazeret Safsatası"],
 ["Appeal To Authority", "Bir Bilen Safsatası"]

 */