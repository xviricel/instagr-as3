package instagrAS3.oauth
{	
	import instagrAS3.events.OAuthEvent;
	import flash.display.NativeWindow;
	import flash.html.HTMLLoader;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	/**
	 * 
	 * 
	 * @author tiago.dias
	 * 
	 */	
	public class OAuth extends EventDispatcher
	{
		private static const OAUTHURL :String = "https://api.instagram.com/oauth/authorize/";
		//private static const ACCESSTOKENURL	:String	= "https://api.instagram.com/oauth/access_token";	
		
		private var _sharedObj				:SharedObject;
		
		private var _consumerKey			:String;
		private var _consumerSecret			:String;
		private var _callbackURL			:String;
		private var _authCode				:String;	
		
		private var _accessToken			:String;
		
		private var _nativeWin				:NativeWindow;
		private var _htmlLoader				:HTMLLoader;
		private var _urlLoader				:URLLoader;
		private var _type					:String;
		
				
		/**
		 * 
		 * 
		 */		
		public function OAuth()
		{
			trace( "OAuth" );
			
			//_urlLoader = new URLLoader();
			//_urlLoader.addEventListener( Event.COMPLETE, onDataComplete );
			//_urlLoader.addEventListener( IOErrorEvent.IO_ERROR, handleError );
			//_urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleError );		
		}
		
		/**
		 * 
		 * 
		 */		
		public function requestAccessToken():void
		{
			trace( "requestAccessToken" );
			
			if ( SharedObject.getLocal( "instagData" ).data.accessToken )
			{				
				accessToken = SharedObject.getLocal( "instagData" ).data.accessToken;
				dispatchEvent( new OAuthEvent( OAuthEvent.SUCCESS ) );
			}
			else
			{
				trace( "!found" )
				var urlReq:URLRequest = new URLRequest( OAUTHURL + "?client_id=" + _consumerKey + "&redirect_uri=" +  _callbackURL + "&response_type=token" );
				var rect:Rectangle = new Rectangle( 300, 300, 700, 500 );
				
				_htmlLoader	= HTMLLoader.createRootWindow( true, null, true, rect );
				_htmlLoader.addEventListener( Event.COMPLETE, accessCodeReceived );
				_htmlLoader.load( urlReq );
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function accessCodeReceived( event:Event ):void
		{
			//trace( "accessCodeReceived()" );
			//
			//var oauthString:String = "?code=";
			//var location:String = _htmlLoader.location;
			//var hasOAuthCode:Boolean = location.indexOf("?code") != -1;
			//var ind:int = location.indexOf( oauthString );
			//
			//trace( location );
			//
			//if ( hasOAuthCode )
			//{
				//_htmlLoader.removeEventListener( Event.COMPLETE, accessCodeReceived );
				//
				//_authCode = location.substr( ind + oauthString.length, location.length );
				//_htmlLoader.stage.nativeWindow.close();
				//_htmlLoader = null;
				//
				//getAccessToken();
			//}
			//else
			//{
				//dispatchEvent( new OAuthEvent( OAuthEvent.ERROR ) );
			//}
			
			trace( "accessCodeReceived()" );
			
			var tokenString:String = "#access_token=";
			var location:String = _htmlLoader.location;
			var hasToken:Boolean = location.indexOf("#access_token") != -1;
			var ind:int = location.indexOf( tokenString );
			
			trace( location );
			
			if ( hasToken )
			{
				_htmlLoader.removeEventListener( Event.COMPLETE, accessCodeReceived );
				
				_authCode = "CODE"; 
				_htmlLoader.stage.nativeWindow.close();
				_htmlLoader = null;
				
				_accessToken = location.substr( ind + tokenString.length, location.length );
			
				_sharedObj = SharedObject.getLocal("instagData");
				_sharedObj.data.accessToken = _accessToken;
												
				dispatchEvent( new OAuthEvent( OAuthEvent.SUCCESS ) );
			}
			else
			{
				dispatchEvent( new OAuthEvent( OAuthEvent.ERROR ) );
			}
		}
		
		/**
		 * 
		 * 
		 */		
		//private function getAccessToken():void
		//{
			//trace( "getAccessToken" );
			//
			//var url:String = ACCESSTOKENURL + "?client_id=" + _consumerKey + "&client_secret=" + _consumerSecret + "&grant_type=authorization_code" + "&redirect_uri=" + _callbackURL + "&code=" + _authCode ;
			//
			//trace( url );
			//
			//var urlRequest:URLRequest = new URLRequest( url );
			//urlRequest.method = URLRequestMethod.POST;
			//
			//_urlLoader.load( urlRequest );
		//}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		//protected function onDataComplete(event:Event):void
		//{
			//trace( "onDataComplete" );
			//
			//var obj:Object = JSON.decode( event.target.data );
			//_accessToken = obj.access_token;
			//
			//_sharedObj = SharedObject.getLocal("instagData");
			//_sharedObj.data.accessToken = _accessToken;
												//
			//dispatchEvent( new OAuthEvent( OAuthEvent.SUCCESS ) );
		//}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function handleError(event:ErrorEvent):void
		{
			trace( event );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get consumerKey():String
		{
			return _consumerKey;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set consumerKey(value:String):void
		{
			_consumerKey = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get consumerSecret():String
		{
			return _consumerSecret;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set consumerSecret(value:String):void
		{
			_consumerSecret = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get callbackURL():String
		{
			return _callbackURL;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set callbackURL(value:String):void
		{
			_callbackURL = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get accessToken():String
		{
			return _accessToken;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set accessToken(value:String):void
		{
			_accessToken = value;
		}
	}
}