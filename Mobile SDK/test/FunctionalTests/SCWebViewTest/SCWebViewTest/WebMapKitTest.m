#import "SCAsyncTestCase.h"

#import <SitecoreMobileSDK/SCMapView.h>
#import <SCMap/SCMapViewController.h>

#import <MapKit/MKPlacemark.h>

@interface WebMapKitTest : SCAsyncTestCase
@end

@implementation WebMapKitTest

-(void)testShowPinsMapViewNormal
{
    PerformNativeTests nativeTests_ = ^( void (^finishCallback_)( BOOL ) )
    {
        [ SCMapViewController setPresentMapViewControllerHendler: ^( SCMapViewController* controller_ )
        {
            __weak SCMapViewController* weakController_ = controller_;
            controller_.mapView.didLoadedAnnotationsHandler = ^( id result_, NSError* error_ )
            {
                NSArray* annotations_ = [ controller_.mapView.annotations select: ^BOOL(id object_)
                {
                    return [ object_ isKindOfClass: [ MKPlacemark class ] ];
                } ];
                BOOL ok_ = ( [ annotations_ count ] == 4 );

                [ weakController_ hideMapViewController ];

                finishCallback_( ok_ );
            };
        } ];
    };

    [ self runTestWithSelector: _cmd
                     testsPath: @"map_view"
                     javasript: @"testMapViewNormal()"
                   nativeTests: nativeTests_ ];
}

-(void)testShowPinsMapViewStrangeSymbols
{
    PerformNativeTests nativeTests_ = ^( void (^finishCallback_)( BOOL ) )
    {
        [ SCMapViewController setPresentMapViewControllerHendler: ^( SCMapViewController* controller_ )
         {
             __weak SCMapViewController* weakController_ = controller_;
             controller_.mapView.didLoadedAnnotationsHandler = ^( id result_, NSError* error_ )
             {
                 NSArray* annotations_ = [ controller_.mapView.annotations select: ^BOOL(id object_)
                                          {
                                              return [ object_ isKindOfClass: [ MKPlacemark class ] ];
                                          } ];
                 BOOL ok_ = ( [ annotations_ count ] == 4 );
                 
                 [ weakController_ hideMapViewController ];
                 
                 finishCallback_( ok_ );
             };
         } ];
    };
    
    [ self runTestWithSelector: _cmd
                     testsPath: @"map_view"
                     javasript: @"testMapViewStrangeSymbols()"
                   nativeTests: nativeTests_ ];
}

-(void)testShowPinsMapViewOtherLanguages
{
    PerformNativeTests nativeTests_ = ^( void (^finishCallback_)( BOOL ) )
    {
        [ SCMapViewController setPresentMapViewControllerHendler: ^( SCMapViewController* controller_ )
         {
             __weak SCMapViewController* weakController_ = controller_;
             controller_.mapView.didLoadedAnnotationsHandler = ^( id result_, NSError* error_ )
             {
                 NSArray* annotations_ = [ controller_.mapView.annotations select: ^BOOL(id object_)
                                          {
                                              return [ object_ isKindOfClass: [ MKPlacemark class ] ];
                                          } ];
                 NSLog( @"[ annotations_ count ]: %d", [ annotations_ count ] );
                 BOOL ok_ = ( [ annotations_ count ] == 3 );
                 
                 [ weakController_ hideMapViewController ];
                 
                 finishCallback_( ok_ );
             };
         } ];
    };
    
    [ self runTestWithSelector: _cmd
                     testsPath: @"map_view"
                     javasript: @"testMapViewOtherLanguages()"
                   nativeTests: nativeTests_ ];
}

@end
