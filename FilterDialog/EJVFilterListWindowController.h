//
//  EVTabSearchWindowController.h
//  SearchTab
//
//  Created by Ethan Vaughan on 12/16/14.
//  Copyright (c) 2014 Ethan James Vaughan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EJVFilterListWindowController : NSWindowController

- (instancetype)initWithArrayController:(NSArrayController *)controller
                   filterPredicateBlock:(NSPredicate *(^)(NSString * searchText))filterPredicateBlock
                          cellViewBlock:(NSTableCellView *(^)(EJVFilterListWindowController * dialog, NSTableCellView * _Nullable reusingView, id object))cellViewBlock;

// Default value: 44.0
@property (nonatomic) CGFloat rowHeight;

// If set, the search text will be cleared whenever the dialog is dismissed (whether by committing a selection, or not)
// Defaults to NO
@property (nonatomic) BOOL clearsSearchTextOnDismiss;

// KVO observable
@property (nonatomic, readonly) NSString *searchText;

@property (nullable, weak) id target;
@property (nullable) SEL selectionCommittedAction;

@end

NS_ASSUME_NONNULL_END
