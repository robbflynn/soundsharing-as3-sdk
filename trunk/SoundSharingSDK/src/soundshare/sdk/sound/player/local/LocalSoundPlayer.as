package soundshare.sdk.sound.player.local
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class LocalSoundPlayer extends EventDispatcher
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		
		private var currentIndex:int = 0;
		private var _playOrder:int = 0;
		
		private var history:Vector.<int> = new Vector.<int>();
		
		public var maxHistory:int = 200;
		public var playlist:Array;
		
		public var _volume:Number = 1;
		
		public function LocalSoundPlayer()
		{
			super();
		}
		
		public function play(index:int = 0):void
		{
			var url:String;
			
			stop();
			
			if (index > -1 && index < playlist.length)
			{
				url = playlist[index].path;
				currentIndex = index;
			}
			
			if (url)
			{
				sound = new Sound();
				sound.load(new URLRequest(url));
				
				soundChannel = sound.play();
				soundChannel.soundTransform = new SoundTransform(volume);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		protected function onSoundComplete(e:Event):void
		{
			next();
		}
		
		public function stop():void
		{
			if (soundChannel)
			{
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				soundChannel.stop();
				soundChannel = null;
				
				sound = null;
			}
		}
		
		public function next():void
		{
			switch (playOrder)
			{
				case 0: // Default (Play once)
					if (currentIndex < playlist.length - 1)
					{
						currentIndex ++;
						play(currentIndex);
					}
					break;
				case 1: // Repeat playlist
					currentIndex = currentIndex == playlist.length - 1 ? 0 : currentIndex + 1;
					play(currentIndex);
					break;
				case 2: // Shuffle
					var index:int = currentIndex;
					
					while (index == currentIndex)
						index = int(playlist.length * Math.random());
					
					addHistoryIndex(index);
					
					currentIndex = index;
					play(currentIndex);
					break;
			}
		}
		
		public function previous():void
		{
			switch (playOrder)
			{
				case 0: // Default (Play once)
					if (currentIndex > 0)
					{
						currentIndex --;
						play(currentIndex);
					}
					break;
				case 1: // Repeat playlist
					currentIndex = currentIndex == 0 ? playlist.length - 1 : currentIndex - 1;
					play(currentIndex);
					break;
				case 2: // Shuffle
					if (history.length > 1)
					{
						history.pop();
						currentIndex = history[history.length - 1];
					}
					else
					{
						var index:int = currentIndex;
						
						while (index == currentIndex)
							index = int(playlist.length * Math.random());
						
						if (history.length == 1)
							history[0] = index;
						
						currentIndex = index;
					}
					
					play(currentIndex);
					break;
			}
		}
		
		public function changePlayOrder(order:int = 0):void
		{
			_playOrder = order;
		}
		
		private function addHistoryIndex(value:int):void
		{
			history.push(value);
			
			if (history.length > maxHistory)
				history.shift();
		}
		
		public function set volume(value:Number):void
		{
			if (soundChannel)
				soundChannel.soundTransform = new SoundTransform(value);
			
			_volume = value;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function get trackIndex():int
		{
			return currentIndex;
		}
		
		public function get playOrder():int
		{
			return _playOrder;
		}
	}
}