
function resultCallback( resultData )
{
    window.location = ( "http://" + resultData )
};

function testMapViewNormal()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( 'onDeviceReady' );

            var maps_ = new scmobile.google_maps.GoogleMaps();
            maps_.drawRoute = true;
            maps_.regionRadius = 100000.;

            {
                var address_ = {};
                address_.title   = 'Address1';
                address_.street  = '43A Staverton Rd';
                address_.city    = 'London';
                address_.zip     = 'NW2 5HA';
                address_.country = 'United Kingdom';
                address_.icon    = 'http://mobilesdk.sc-demo.net/Products/Digital_SLR/Full_featured/~/media/Mobile%20SDK/mobile_email.ashx';

                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address2';
                address_.street  = '1 Fir Trees Close';
                address_.city    = 'London';
                address_.zip     = 'SE16';
                address_.country = 'UK';
                address_.icon    = 'http://mobilesdk.sc-demo.net/Products/Digital_SLR/Full_featured/~/media/Mobile%20SDK/mobile_tweet.ashx';

                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address3';
                address_.street  = '25B Trinity Church Square';
                address_.city    = 'London';
                address_.zip     = 'SE1 4HY';
                address_.country = 'UK';
                address_.icon    = 'http://mobilesdk.sc-demo.net/Products/Digital_SLR/Full_featured/~/media/Mobile%20SDK/mobile_tweet_camera.ashx';

                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address4';
                address_.street  = '48 Cowcross St';
                address_.city    = 'London Borough of Islington';
                address_.zip     = 'EC1M 6BY';
                address_.country = 'UK';
                address_.icon    = 'http://mobilesdk.sc-demo.net/Products/Digital_SLR/Full_featured/~/media/Mobile%20SDK/mobile_tweet_photo.ashx';

                maps_.addresses.push( address_ );
            }

            maps_.show();

            resultCallback( "PERFORM_NATIVE_TESTS" );
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};


function testMapViewStrangeSymbols()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( 'onDeviceReady' );
            
            var maps_ = new scmobile.google_maps.GoogleMaps();
            maps_.drawRoute = false;
            maps_.regionRadius = 100000.;
            
            {
                var address_ = {};
                address_.title   = 'Address1';
                address_.city    = 'Kamianets-Podilskyi';
                address_.zip     = '32307';
                address_.state   = "Khmel'nyts'ka";
                address_.country = 'Ukraine';
                
                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address2';
                address_.city    = 'Francisco I. Madero';
                address_.country = 'México';
                
                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address3';
                address_.street  = '25 Regele Ferdinand Street';
                address_.city    = 'Cluj-Napoca';
                address_.country = 'Romania';
                
                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address4';
                address_.street  = 'Üsküp Caddesi, 24';
                address_.city    = 'Ankara';
                address_.country = 'Turkey';

                maps_.addresses.push( address_ );
            }
            
            maps_.show();
            
            resultCallback( "PERFORM_NATIVE_TESTS" );
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};


function testMapViewOtherLanguages()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( 'onDeviceReady' );
            
            var maps_ = new scmobile.google_maps.GoogleMaps();
            maps_.drawRoute = false;
            maps_.regionRadius = 100000.;
            
            {
                var address_ = {};
                address_.title   = 'Адрес №1';
                address_.street  = 'Красная пл., д. 1';
                address_.city    = 'Москва';
                address_.country = 'Россия';
                
                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Адреса №2';
                address_.street  = '12, Старонаводницька вулиця';
                address_.city    = 'Київ';
                address_.country = 'Україна';
                
                maps_.addresses.push( address_ );
            }
            {
                var address_ = {};
                address_.title   = 'Address 3';
                address_.street  = 'Via dei Pioppi, 4';
                address_.city    = "Sant'Antimo";
                address_.country = 'Italia';
                
                maps_.addresses.push( address_ );
            }

            maps_.show();
            
            resultCallback( "PERFORM_NATIVE_TESTS" );
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};


