//
//  EVTabSearchWindowController.h
//  SearchTab
//
//  Created by Ethan Vaughan on 12/16/14.
//  Copyright (c) 2014 Ethan James Vaughan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kEJVFilterListPredicateSubstitutionVariableName;

@interface EJVFilterListWindowController : NSWindowController

- (instancetype)initWithArrayController:(NSArrayController *)controller
                        filterPredicate:(NSPredicate *)filterPredicate
                          cellViewBlock:(NSTableCellView *(^)(NSTableCellView * _Nullable reusingView, id object))cellViewBlock;

// Default value: 44.0
@property (nonatomic) CGFloat rowHeight;

@property (nullable, weak) id target;
@property (nullable) SEL selectionCommittedAction;

@end

NS_ASSUME_NONNULL_END
