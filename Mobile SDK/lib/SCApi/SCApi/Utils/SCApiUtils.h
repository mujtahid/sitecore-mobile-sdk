#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

#include "JSBlocksDefinitions.h"

@class SCSitecoreCredentials;
@class SCCreateMediaItemRequest;

JFFAsyncOperation firstItemFromArrayReader( JFFAsyncOperation loader_ );

JFFAsyncOperation asyncOpWithValidPath( JFFAsyncOperationBinder binder_, NSString* path_ );
JFFAsyncOperation asyncOpWithValidIds( JFFAsyncOperationBinder binder_, NSArray* ids_ );

JFFAsyncOperation itemRecordsPageToItemsPage( JFFAsyncOperation asyncOp_ );

JFFAsyncOperation itemPageToItems( JFFAsyncOperation loader_ );

JFFAsyncOperation scDataURLResponseLoader( NSURL* url_
                                          , SCSitecoreCredentials* credentials_
                                          , NSData* httpBody_
                                          , NSString* httpMethod_
                                          , NSDictionary* headers_ );
