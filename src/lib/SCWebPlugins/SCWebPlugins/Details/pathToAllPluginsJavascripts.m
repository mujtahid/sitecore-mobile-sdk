#include "pathToAllPluginsJavascripts.h"

#import "SCWebPlugin.h"

#include "SCMobilePluginsJavaScriptExport.h"

NSArray* scWebPluginsClasses( void )
{
    static NSArray* instance_;
	static dispatch_once_t predicate_;

	dispatch_once( &predicate_, ^void( void )
    {
        NSMutableArray* plugins_ = [ NSMutableArray new ];

        enumerateAllClassesWithBlock( ^( Class class_ )
        {
            BOOL conformsProtocol_ = [ class_ conformsToProtocol: @protocol( SCWebPlugin ) ];
            if ( conformsProtocol_ )
                [ plugins_ addObject: class_ ];
        } );

        instance_ = [ plugins_ copy ];
    } );

    return instance_;
}

static void writeAllJSToFileAtPath( NSString* path_ )
{
    NSArray* plugins_javascripts_ = [ scWebPluginsClasses() map: ^id( id object_ )
    {
        Class pluginClass_ = object_;
        if ( [ pluginClass_ hasClassMethodWithSelector: @selector( pluginJavascript ) ] )
        {
            NSString* str_ = [ pluginClass_ pluginJavascript ];
            return str_ ?: @"";
        }
        return @"";
    } ];

    NSString* pluginJs_ = [ plugins_javascripts_ componentsJoinedByString: @"\n" ];
    NSString* allJs_ = [ scWebPluginsCoreJavascript() stringByAppendingString: pluginJs_ ];

    NSError* fsError_ = nil;
    [ allJs_ writeToFile: path_
              atomically: YES
                encoding: NSUTF8StringEncoding
                   error: &fsError_ ];
    
    [ fsError_ writeErrorToNSLog ];
}

NSString* pathToAllPluginsJavascripts()
{
    static NSString* instance_;
    static dispatch_once_t predicate_;

    dispatch_once( &predicate_, ^void( void )
    {
        NSString* path_ = [ NSString documentsPathByAppendingPathComponent: @"scmobile_main.js" ];
        writeAllJSToFileAtPath( path_ );
        instance_ = path_;
    } );

    return instance_;
}
