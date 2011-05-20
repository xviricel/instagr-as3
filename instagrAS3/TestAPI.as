package instagrAS3
{
	import instagrAS3.Instagram;
	import instagrAS3.oauth.OAuth;
	import instagrAS3.events.OAuthEvent;
	import instagrAS3.events.InstagramEvent;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.demonsters.debugger.MonsterDebugger;	//v3
	
	/**
	 * ...
	 * @author pbordachar
	 */
	
	public class TestAPI extends Sprite 
	{
		[Embed(source = "assets/instagram.jpg")] 
		private var itgLogo:Class;
		
		private var _oauth:OAuth;
		private var _instagram:Instagram;
		private var _container:Sprite;
		
		// http://instagr.am/developer/manage/
		/*
		 app name : xxxx
		 client id : xxxx
		 client secret : xxxx
		 callback url : xxxx
		*/
		 
		public function TestAPI():void 
		{
			_oauth = new OAuth();	
			_oauth.consumerKey 		= "xxxx";
			_oauth.consumerSecret 	= "xxxx";
			_oauth.callbackURL 		= "xxxx";
			_oauth.addEventListener( OAuthEvent.SUCCESS, onAuthentication );
			_oauth.requestAccessToken();
		}
		
		protected function onAuthentication( e:Event ):void
		{
			trace( "onAuthentication" );
			
			_instagram	= new Instagram();
			_instagram.oauth = _oauth;
			_instagram.addEventListener( InstagramEvent.REQUEST_COMPLETE, handleDataComplete );

			setUI();
		}
		
		protected function handleDataComplete( e:InstagramEvent):void
		{
			trace( "handleDataComplete" );
			
			MonsterDebugger.initialize( this );
			MonsterDebugger.trace( this, e.data );
		}

		// - - -
		
		private function setUI():void
		{
			var itgLogo:DisplayObject = new itgLogo();
			itgLogo.x = 5;
			itgLogo.y = 10;
			addChild( itgLogo );
			
			var getUser:PushButton = new PushButton(this, 20, 80, "Get User", itgGetUser );
			var getFeed:PushButton = new PushButton(this, 20, 110, "Self Feed", itgGetFeed );
			var getPhoto:PushButton = new PushButton(this, 20, 140, "Get Photo", itgGetPhoto );
			var getUserRecent:PushButton = new PushButton(this, 20, 170, "User Recent", itgGetUserRecent );
			var getUserSearch:PushButton = new PushButton(this, 20, 200, "User search", itgGetUserSearch );
			var getPhotoSearch:PushButton = new PushButton(this, 20, 230, "Photo search", itgGetPhotoSearch );
			var getPopular:PushButton = new PushButton(this, 20, 260, "Most Popular", itgGetPopular );
			var getLocation:PushButton = new PushButton(this, 20, 290, "Get Location", itgGetLocation );
			var getLocationRecent:PushButton = new PushButton(this, 20, 320, "Location Recent", itgGetLocationRecent );
			var getLocationSearch:PushButton = new PushButton(this, 20, 350, "Location search", itgGetLocationSearch );
			var getTag:PushButton = new PushButton(this, 20, 380, "Get Tag", itgGetTag );
			var getTagRecent:PushButton = new PushButton(this, 20, 410, "Tag Recent", itgGetTagRecent );
			var getTagSearch:PushButton = new PushButton(this, 20, 440, "Tag search", itgGetTagSearch );
			
			_container = new Sprite();
			_container.x = 260;
			_container.y = 220;
			addChild( _container );
		}
		
		private function clear():void
		{
			while ( _container.numChildren )
			{
				_container.removeChildAt( 0 );
			}
		}

		// See the authenticated user's feed.
		
		private function itgGetFeed( e:Event ):void
		{
			clear();
			
			var max:Label = new Label( _container, 10, 10, "max ID" );
			var maxID:InputText = new InputText(_container, 10, 30, "" );
			var min:Label = new Label( _container, 10, 50, "min ID" );
			var minID:InputText = new InputText(_container, 10, 70, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 68, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&max_id=" + maxID.text;
				params += "&min_id=" + minID.text;
				
				itgCall( "getFeed", [ params ] );
			}
		}
		
		// Get basic information about a user.
		
		private function itgGetUser( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "User ID or self" );
			var userID:InputText = new InputText(_container, 10, 30, "self" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 28, "SEND", send )
			
			function send():void
			{
				itgCall( "getUser", [userID.text] );
			}
		}
		
		// Get the most recent media published by a user.
		
		private function itgGetUserRecent( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "User ID or self" );
			var userID:InputText = new InputText(_container, 10, 30, "self" );
			var max:Label = new Label( _container, 10, 50, "max ID" );
			var maxID:InputText = new InputText(_container, 10, 70, "" );
			var min:Label = new Label( _container, 10, 90, "min ID" );
			var minID:InputText = new InputText(_container, 10, 110, "" );
			var max2:Label = new Label( _container, 10, 50, "max TS" );
			var maxTS:InputText = new InputText(_container, 10, 70, "" );
			var min2:Label = new Label( _container, 10, 90, "min TS" );
			var minTS:InputText = new InputText(_container, 10, 110, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 108, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&max_id=" + maxID.text 
				params += "&min_id=" + minID.text;
				params += "&max_timestamp=" + maxTS.text;
				params += "&min_timestamp=" + minTS.text;
				
				itgCall( "getUserRecent", [ userID.text, params ]);
			}			
		}
		
		// Search for a user by name.
		
		private function itgGetUserSearch( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "Search for" );
			var search:InputText = new InputText(_container, 10, 30, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 28, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&q=" + search.text 
				
				itgCall( "getUserSearch", [ params ]);
			}			
		}
		
		// Get information about a media object
		
		private function itgGetPhoto( e:Event ):void
		{
			clear();
			
			var labelL:Label = new Label( _container, 10, 10, "Photo ID" );
			var photoID:InputText = new InputText(_container, 10, 30, "44011372" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 28, "SEND", send )
			
			function send():void
			{
				itgCall( "getPhoto", [ photoID.text ]);
			}			
		}
		
		// Search for media in a given area.
		
		private function itgGetPhotoSearch( e:Event ):void
		{
			clear();
			
			var latitude:Label = new Label( _container, 10, 10, "latitude" );
			var lat:InputText = new InputText(_container, 10, 30, "43.500" );
			var longitude:Label = new Label( _container, 10, 50, "longitude" );
			var long:InputText = new InputText(_container, 10, 70, "-1.467" ); // bayonne
			var distance:Label = new Label( _container, 10, 90, "distance" );
			var dist:InputText = new InputText(_container, 10, 110, "" );
			var max2:Label = new Label( _container, 10, 130, "max TS" );
			var maxTS:InputText = new InputText(_container, 10, 150, "" );
			var min2:Label = new Label( _container, 10, 170, "min TS" );
			var minTS:InputText = new InputText(_container, 10, 190, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 188, "SEND", send )
			
			function send():void
			{
				var d:int = ( parseInt( dist.text ) > 5000 ) ? 5000 : 1000; // default value in meters
				
				var params:String;
				params =  "&lat=" + lat.text 
				params += "&lng=" + long.text;
				params += "&distance=" + d; 
				params += "&max_timestamp=" + maxTS.text;
				params += "&min_timestamp=" + minTS.text;
				
				itgCall( "getPhotoSearch", [ params ] );
			}			
		}
		
		// Get a list of what media is most popular at the moment.
		
		private function itgGetPopular( e:Event ):void
		{
			clear();
			
			var popular:Label = new Label( _container, 10, 10, "most popular" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 8, "SEND", send )
			
			function send():void
			{
				itgCall( "getPhotoPopular");
			}
		}
		
		// Get information about a location
		
		private function itgGetLocation( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "Loc ID" );
			var locID:InputText = new InputText(_container, 10, 30, "1" );
			var max:Label = new Label( _container, 10, 50, "max ID" );
			var maxID:InputText = new InputText(_container, 10, 70, "" );
			var min:Label = new Label( _container, 10, 90, "min ID" );
			var minID:InputText = new InputText(_container, 10, 110, "" );
			var max2:Label = new Label( _container, 10, 130, "max TS" );
			var maxTS:InputText = new InputText(_container, 10, 150, "" );
			var min2:Label = new Label( _container, 10, 170, "min TS" );
			var minTS:InputText = new InputText(_container, 10, 190, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 188, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&max_id=" + maxID.text 
				params += "&min_id=" + minID.text;
				params += "&max_timestamp=" + maxTS.text;
				params += "&min_timestamp=" + minTS.text;
				
				itgCall( "getLocation", [ locID.text, params ] );
			}
		}
		
		// Get a list of recent media objects from a given location
		
		private function itgGetLocationRecent( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "Loc ID" );
			var locID:InputText = new InputText(_container, 10, 30, "1" );
			var max:Label = new Label( _container, 10, 50, "max ID" );
			var maxID:InputText = new InputText(_container, 10, 70, "" );
			var min:Label = new Label( _container, 10, 90, "min ID" );
			var minID:InputText = new InputText(_container, 10, 110, "" );
			var max2:Label = new Label( _container, 10, 130, "max TS" );
			var maxTS:InputText = new InputText(_container, 10, 150, "" );
			var min2:Label = new Label( _container, 10, 170, "min TS" );
			var minTS:InputText = new InputText(_container, 10, 190, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 188, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&max_id=" + maxID.text 
				params += "&min_id=" + minID.text;
				params += "&max_timestamp=" + maxTS.text;
				params += "&min_timestamp=" + minTS.text;
				
				itgCall( "getLocationRecent", [ locID.text, params ] );
			}
		}
		
		// Search for a location by name and geographic coordinate.
		
		private function itgGetLocationSearch( e:Event ):void
		{
			clear();
			
			var latitude:Label = new Label( _container, 10, 10, "latitude" );
			var lat:InputText = new InputText(_container, 10, 30, "43.500" );
			var longitude:Label = new Label( _container, 10, 50, "longitude" );
			var long:InputText = new InputText(_container, 10, 70, "-1.467" ); // bayonne
			var distance:Label = new Label( _container, 10, 90, "distance" );
			var dist:InputText = new InputText(_container, 10, 110, "" );
			var foursquare:Label = new Label( _container, 10, 130, "foursquareID" );
			var foursquareID:InputText = new InputText(_container, 10, 150, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 148, "SEND", send )
			
			function send():void
			{
				var d:int = ( parseInt( dist.text ) > 5000 ) ? 5000 : 1000; // default value in meters
				
				var params:String;
				params =  "&lat=" + lat.text 
				params += "&lng=" + long.text;
				params += "&distance=" + d; 
				params += "&foursquare_id=" + foursquareID.text;
				
				itgCall( "getLocationSearch", [ params ] );
			}			
		}
		
		// Get information about a tag object.
		
		private function itgGetTag( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "Tag name" );
			var name:InputText = new InputText(_container, 10, 30, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 28, "SEND", send )
			
			function send():void
			{
				itgCall( "getTag", [ name.text ]);
			}			
		}
		
		// Get a list of recently tagged media
		
		private function itgGetTagRecent( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "Tag" );
			var search:InputText = new InputText(_container, 10, 30, "" );
			var max:Label = new Label( _container, 10, 50, "max ID" );
			var maxID:InputText = new InputText(_container, 10, 70, "" );
			var min:Label = new Label( _container, 10, 90, "min ID" );
			var minID:InputText = new InputText(_container, 10, 110, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 28, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&max_id=" + maxID.text 
				params += "&min_id=" + minID.text;
				
				itgCall( "getTagRecent", [ search.text, params ]);
			}			
		}
		
		// Search for tags by name
		
		private function itgGetTagSearch( e:Event ):void
		{
			clear();
			
			var label:Label = new Label( _container, 10, 10, "Search for" );
			var search:InputText = new InputText(_container, 10, 30, "" );
			var sendBtn:PushButton = new PushButton ( _container, 120, 28, "SEND", send )
			
			function send():void
			{
				var params:String;
				params =  "&q=" + search.text;
				
				itgCall( "getTagSearch", [ params ]);
			}			
		}
		
		
		
		// Get most recent media from a geography subscription that you created
		
		
		
		// TODO / extended scope

		// Get a list of users who have liked this media.
		// Set a like on this media by the currently authenticated user.
		// Remove a like on this media by the currently authenticated user.
		
		// Get information about a tag object.
		// Get a list of recently tagged media.
		// Search for tags by name.
		
		// Get a full list of comments on a media.
		// Create a comment on a media.
		// Remove a comment either on the authenticated user's media or authored by the authenticated user.
		
		
		
		///////////////////////////
		///////  C A L L S  ///////
		///////////////////////////

		private function itgCall( method:String, args:Array = null ):void
		{
			switch ( method )
			{
				case "getFeed":
					_instagram.getFeed( args[0] );
					break;
				case "getUser":
					_instagram.getUser( args[0] );
					break;
				case "getUserRecent":
					_instagram.getUserRecent( args[0], args[ 1 ] );
					break;
				case "getUserSearch":
					_instagram.getUserSearch( args[0] );
					break;
				case "getPhoto":
					_instagram.getPhoto( args[0] );
					break;
				case "getPhotoSearch":
					_instagram.getPhotoSearch( args[0] );
					break;
				case "getPhotoPopular":
					_instagram.getPhotoPopular();
					break;
				case "getLocation":
					_instagram.getLocation( args[0], args[ 1 ] );
					break;
				case "getLocationRecent":
					_instagram.getLocationRecent( args[0], args[ 1 ] );
					break;
				case "getLocationSearch":
					_instagram.getLocationSearch( args[0] );
					break;
				case "getTag":
					_instagram.getTag( args[0] );
					break;
				case "getTagRecent":
					_instagram.getTagRecent( args[0], args[1] );
					break;
				case "getTagSearch":
					_instagram.getTagSearch( args[0] );
					break;
				
			}
		}
		
	}
	
}