package soundshare.sdk.db.mongo.playlists.loader.events
{
	import flash.events.Event;
	
	public class PlaylistsLoaderEvent extends Event
	{
		public static const PLAYLIST_COMPLETE:String = "playlistComplete";
		public static const PLAYLIST_ERROR:String = "playlistError";
		
		public static const PLAYLISTS_COMPLETE:String = "playlistsComplete";
		public static const PLAYLISTS_ERROR:String = "playlistsError";
		
		public var playlists:Array;
		
		public function PlaylistsLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}