#import "SCWebApiParsers.h"

#import "SCError.h"

#import "SCItemRecordsPage+JsonParser.h"

static JFFAsyncOperation invalidResponseFormatLoader( NSData* data_ )
{
    SCInvalidResponseFormatError* error_ = [ SCInvalidResponseFormatError new ];
    error_.responseData = data_;
    return asyncOperationWithError( error_ );
}

JFFAsyncOperation webApiJSONAnalyzer( NSURL* url_, NSData* data_ )
{
    return asyncOperationWithAnalyzer( data_, ^id( id data_, NSError** outError_ )
    {
        //TODO test logs, just uncomment
        //NSString* responseStr_ = [ [ NSString alloc ] initWithData: data_
        //                                                  encoding: NSUTF8StringEncoding ];
        //NSLog( @"response: %@ for url: %@", responseStr_, url_ );

        NSError* localError_ = nil;
        //STODO parse in separate thread
        //STODO test
        NSDictionary* json_ = [ NSJSONSerialization JSONObjectWithData: data_
                                                               options: 0
                                                                 error: &localError_ ];

        if ( localError_ )
        {
            NSString* responseStr_ = [ [ NSString alloc ] initWithData: data_
                                                              encoding: NSUTF8StringEncoding ];
            NSLog( @"can not process response: %@ for url: %@", responseStr_, url_ );
            SCInvalidResponseFormatError* srvError_ = [ SCInvalidResponseFormatError new ];
            srvError_.responseData = data_;
            localError_ = srvError_;
        }
        else
        {
            NSDictionary* errorJson_ = [ json_ objectForKey: @"error" ];
            if ( errorJson_ )
            {
                SCResponseError* srvError_ = [ SCResponseError new ];

                srvError_.statusCode = [ [ json_ objectForKey: @"statusCode" ] integerValue ];
                srvError_.message = [ errorJson_ objectForKey: @"message" ];
                srvError_.type    = [ errorJson_ objectForKey: @"type"    ];
                srvError_.method  = [ errorJson_ objectForKey: @"method"  ];
                localError_ = srvError_;
            }
        }

        [ localError_ setToPointer: outError_ ];

        return localError_ ? nil : json_;
    } );
}

JFFAsyncOperationBinder deleteItemsJSONResponseParser( NSData* responseData_ )
{
    return ^JFFAsyncOperation( NSDictionary* json_ )
    {
        if ( ![ json_ isKindOfClass: [ NSDictionary class ] ] )
        {
            return invalidResponseFormatLoader( responseData_ );
        }

        NSDictionary* result_ = [ json_ objectForKey: @"result" ];

        if ( ![ result_ isKindOfClass: [ NSDictionary class ] ] )
        {
            return invalidResponseFormatLoader( responseData_ );
        }

        NSArray* itemsDeleted_ = [ result_ objectForKey: @"itemIds" ];

        if ( ![ itemsDeleted_ isKindOfClass: [ NSArray class ] ] )
        {
            return invalidResponseFormatLoader( responseData_ );
        }

        return asyncOperationWithResult( itemsDeleted_ );
    };
}

SCAsyncBinderForURL itemsJSONResponseAnalyzerWithApiCntext( SCApiContext* apiContext_ )
{
    return ^JFFAsyncOperationBinder( NSURL* url_ )
    {
        return ^JFFAsyncOperation( NSData* responseData_ )
        {
            JFFAsyncOperation loader_ = webApiJSONAnalyzer( url_, responseData_ );

            JFFAsyncOperationBinder parseItemsBinder_ =
            [ SCItemRecordsPage itemRecordsWithResponseData: responseData_
                                                 apiContext: apiContext_ ];
            return bindSequenceOfAsyncOperations( loader_, parseItemsBinder_, nil );
        };
    };
}
