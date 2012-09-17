package soundshare.sdk.sound.channels.playlist
{
	import flash.utils.ByteArray;
	
	import soundshare.sdk.builders.sound.drainer.DrainerBuilder;
	import soundshare.sdk.builders.sound.drainer.events.DrainerBuilderEvent;
	import soundshare.sdk.sound.channels.base.SoundChannel;
	import soundshare.sdk.sound.channels.playlist.events.PlaylistsChannelEvent;
	import soundshare.sdk.sound.drainers.ISoundDrainer;
	
	public class PlaylistChannel extends SoundChannel
	{
		private var drainerBuilder:DrainerBuilder;
		
		private var _playlist:Array;
		private var currentSong:int = 0;
		
		private var drainers:Vector.<ISoundDrainer> = new Vector.<ISoundDrainer>();
		private var playbackQueue:Vector.<Object> = new Vector.<Object>();
		private var buffer:ByteArray = new ByteArray();
		
		private var ready:Boolean = false;
		
		public var playOrder:int = 0;
		
		public function PlaylistChannel()
		{ 
			this.drainerBuilder = new DrainerBuilder();
			this.drainerBuilder.addEventListener(DrainerBuilderEvent.BUILD_COMPLETE, onBuildDrainerComplete);
			this.drainerBuilder.addEventListener(DrainerBuilderEvent.BUILD_ERROR, onBuildDrainerError);
		}
		
		// ********************************************************************************************************************************
		// ********************************************************************************************************************************
		// ********************************************************************************************************************************
		
		public function play(index:int = 0):void
		{
			trace("-PlaylistsChannel[play]-", (playlist.length > 0 && index < playlist.length));
			
			if (playlist.length > 0 && index < playlist.length)
			{
				if (drainers.length > 0)
					drainerBuilder.addToCache(drainers.shift());
				
				currentSong = index;
				
				trace("-PlaylistsChannel[play]-", currentSong);
				
				buildDrainer();
			}
		}
		
		public function next():void
		{
			stop();
			buildNextDrainer();
		}
		
		public function previous():void
		{
			stop();
			buildPreviousDrainer();
		}
		
		public function back():void
		{
			stop();
			buildPreviousDrainer();
		}
		
		public function stop():void
		{
			if (drainers.length > 0)
				drainerBuilder.addToCache(drainers.shift());
		}
		
		public function reset():void
		{
			stop();
			ready = false;
		}
		
		private function onBuildDrainerComplete(e:DrainerBuilderEvent):void
		{
			trace("-onBuildDrainerComplete-");
			drainers.push(e.drainer);
			
			var event1:PlaylistsChannelEvent = new PlaylistsChannelEvent(PlaylistsChannelEvent.CHANGE_SONG);
			event1.songIndex = currentSong;
			
			dispatchEvent(event1);
			
			var event2:PlaylistsChannelEvent = new PlaylistsChannelEvent(PlaylistsChannelEvent.AUDIO_INFO_DATA);
			event2.data = audioInfoData;
			
			dispatchEvent(event2);
		}
		
		private function onBuildDrainerError(e:DrainerBuilderEvent):void
		{
			trace("-onBuildDrainerError-");
			
			var event:PlaylistsChannelEvent = new PlaylistsChannelEvent(PlaylistsChannelEvent.CHANGE_SONG);
			event.songIndex = currentSong;
			
			dispatchEvent(event);
			
			drainerBuilder.addToCache(e.drainer);
			dispatchEvent(new PlaylistsChannelEvent(PlaylistsChannelEvent.LOAD_AUDIO_DATA_ERROR));
		}
		
		public function addToPlaybackQueue(index:int):void
		{
			if (playlist.length > 0 && index < playlist.length)
				playbackQueue.push(playlist[index]);
		}
		
		override public function prepare(size:int):void
		{
			buffer.clear();
			
			if (ready && drainers.length > 0)
			{
				var samples:int = drainers[0].drain(size, buffer);
				buffer.position = 0;
				
				//trace("-prepare-", samples);
				
				if (samples == 0)
				{
					drainerBuilder.addToCache(drainers.shift());
					
					if (!drainerBuilder.inProgress)
						buildNextDrainer();
				}
			}
			/*else
				trace("-prepare-", ready, drainers.length > 0);*/
		}
		
		private function buildDrainer():void
		{
			var mediaData:Object = playlist[currentSong];
			
			if (mediaData)
				drainerBuilder.build(mediaData);
		}
		
		private function buildNextDrainer():void
		{
			var mediaData:Object = getNextSongData();
			
			if (mediaData)
				drainerBuilder.build(mediaData);
		}
		
		private function buildPreviousDrainer():void
		{
			var mediaData:Object = getPreviousSongData();
			
			if (mediaData)
				drainerBuilder.build(mediaData);
		}
		
		/*
		*
		* 0: Default (Play once)
		* 1: Repeat playlist
		* 2: Shuffle
		*
		*/
		
		public var maxHistory:int = 200;
		private var history:Vector.<int> = new Vector.<int>();
		
		private function getNextSongData():Object
		{
			var mediaData:Object;
			
			trace("1.getNextSongData:", mediaData, currentSong, playOrder, playbackQueue.length);
			
			if (playbackQueue.length > 0)
				mediaData = playbackQueue.shift();
			else
			{
				switch (playOrder)
				{
					case 0: // Default (Play once)
						if (currentSong < playlist.length - 1)
						{
							currentSong ++;
							mediaData = playlist[currentSong];
						}
						else
							dispatchEvent(new PlaylistsChannelEvent(PlaylistsChannelEvent.STOP_PLAYING));
						break;
					case 1: // Repeat playlist
						currentSong = currentSong == playlist.length - 1 ? 0 : currentSong + 1;
						mediaData = playlist[currentSong];
						break;
					case 2: // Shuffle
						var index:int = currentSong;
						
						while (index == currentSong)
							index = int(playlist.length * Math.random());
						
						addHistoryIndex(index);
						
						trace("2.getNextSongData:", index, currentSong);
						
						currentSong = index;
						mediaData = playlist[currentSong];
						break;
				}
			}
			
			trace("3.getNextSongData:", mediaData, currentSong, playOrder);
			
			return mediaData;
		}
		
		private function addHistoryIndex(value:int):void
		{
			history.push(value);
			
			if (history.length > maxHistory)
				history.shift();
		}
		
		private function getPreviousSongData():Object
		{
			var mediaData:Object;
			
			trace("getPreviousSongData:", history.length, currentSong);
			
			switch (playOrder)
			{
				case 0: // Default (Play once)
					if (currentSong > 0)
					{
						currentSong --;
						mediaData = playlist[currentSong];
					}
					else
						dispatchEvent(new PlaylistsChannelEvent(PlaylistsChannelEvent.STOP_PLAYING));
					break;
				case 1: // Repeat playlist
					currentSong = currentSong == 0 ? playlist.length - 1 : currentSong - 1;
					mediaData = playlist[currentSong];
					break;
				case 2: // Shuffle
					if (history.length > 1)
					{
						history.pop();
						
						currentSong = history[history.length - 1];
						mediaData = playlist[currentSong];
					}
					else
					{
						var index:int = currentSong;
						
						while (index == currentSong)
							index = int(playlist.length * Math.random());
						
						if (history.length == 1)
							history[0] = index;
						
						currentSong = index;
						mediaData = playlist[currentSong];
					}
					break;
			}
			
			trace("getPreviousSongData:", mediaData, currentSong);
			
			return mediaData;
		}
		
		private function getBackSongData():Object
		{
			var mediaData:Object;
			
			trace("getBackSongData:", history.length);
			
			if (history.length > 1)
				history.pop();
			
			if (history.length > 0)
			{
				currentSong = history[history.length - 1];
				mediaData = playlist[currentSong];
			}
			else
			{
				switch (playOrder)
				{
					case 0: // Default (Play once)
						if (currentSong > 0)
						{
							currentSong --;
							
							addHistoryIndex(currentSong);
							mediaData = playlist[currentSong];
						}
						else
							dispatchEvent(new PlaylistsChannelEvent(PlaylistsChannelEvent.STOP_PLAYING));
						break;
					case 1: // Repeat playlist
						currentSong = currentSong == 0 ? playlist.length - 1 : currentSong - 1;
						
						addHistoryIndex(currentSong);
						mediaData = playlist[currentSong];
						break;
					case 2: // Shuffle
						var index:int;
						
						while (index != currentSong)
							index = int(playlist.length * Math.random());
						
						history.push(index);
						addHistoryIndex(index);
						
						currentSong = index;
						mediaData = playlist[currentSong];
						break;
				}
			}
			
			trace("getBackSongData:", mediaData, currentSong);
			
			return mediaData;
		}
		
		override public function readFloat():Number
		{
			if (!ready || buffer.length == 0 || buffer.length == buffer.position)
				return 0;
			
			return buffer.readFloat();
		}
		
		// ********************************************************************************************************************************
		// ********************************************************************************************************************************
		// ********************************************************************************************************************************
		
		public function get audioInfoData():Object
		{
			if (ready && drainers.length > 0)
				return drainers[0].audioInfoData;
			
			return null;
		}
		
		public function set playlist(value:Array):void
		{
			_playlist = value;
			ready = value && value.length > 0;
		}
		
		public function get playlist():Array
		{
			return _playlist;
		}
		
		public function get songIndex():int
		{
			return currentSong;
		}
	}
}