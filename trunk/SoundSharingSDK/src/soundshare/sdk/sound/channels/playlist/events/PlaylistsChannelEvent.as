package soundshare.sdk.sound.channels.playlist.events
{
	import flash.events.Event;
	
	public class PlaylistsChannelEvent extends Event
	{
		public static const AUDIO_INFO_DATA:String = "audioInfoData";
		
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		
		public static const CHANGE_SONG:String = "changeSong";
		
		public static const START_PLAYING:String = "startPlaying";
		public static const STOP_PLAYING:String = "stopPlaying";
		
		public static const LOAD_AUDIO_DATA_ERROR:String = "LOAD_AUDIO_DATA_ERROR";
		
		public var data:Object;
		
		public var songIndex:int;
		
		public function PlaylistsChannelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:PlaylistsChannelEvent = new PlaylistsChannelEvent(type, bubbles, cancelable);
			e.data = data;
			e.songIndex = songIndex;
			
			return e;
		}
	}
}