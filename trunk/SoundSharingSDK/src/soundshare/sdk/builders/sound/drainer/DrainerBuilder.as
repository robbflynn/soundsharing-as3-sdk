package soundshare.sdk.builders.sound.drainer
{
	import flash.events.EventDispatcher;
	
	import soundshare.sdk.builders.sound.drainer.events.DrainerBuilderEvent;
	import soundshare.sdk.sound.drainers.ISoundDrainer;
	import soundshare.sdk.sound.drainers.events.DrainerEvent;
	import soundshare.sdk.sound.drainers.file.MP3FileDrainer;
	
	import utils.cache.CacheFactory;
	
	public class DrainerBuilder extends EventDispatcher
	{
		private var playlist:Array = new Array();
		
		private var _inProgress:Boolean = false;
		
		private var cahce:CacheFactory;
		private var drainer:ISoundDrainer;
		
		public function DrainerBuilder()
		{
			super();
			
			this.cahce = new CacheFactory();
		}
		
		public function build(mediaData:Object):void
		{
			trace("-DrainerBuilder-");
			
			if (_inProgress)
				stop();
			
			_inProgress = true;
			
			drainer = cahce.pull(MP3FileDrainer) as ISoundDrainer;
			
			if (!drainer)
				drainer = new MP3FileDrainer();
			
			trace("DrainerBuilder[build]:", drainer);
			
			drainer.addEventListener(DrainerEvent.READY, onDrainerReady);
			drainer.addEventListener(DrainerEvent.ERROR, onDrainerError);
			drainer.load(mediaData);
		}
		
		private function onDrainerReady(e:DrainerEvent):void
		{
			trace("-DrainerBuilder[onDrainerReady]-");
			
			_inProgress = false;
			
			e.currentTarget.removeEventListener(DrainerEvent.READY, onDrainerReady);
			e.currentTarget.removeEventListener(DrainerEvent.ERROR, onDrainerError);
			
			var event:DrainerBuilderEvent = new DrainerBuilderEvent(DrainerBuilderEvent.BUILD_COMPLETE);
			event.drainer = e.currentTarget as ISoundDrainer;
			
			dispatchEvent(event);
		}
		
		private function onDrainerError(e:DrainerEvent):void
		{
			trace("-DrainerBuilder[onDrainerError]-");
			
			_inProgress = false;
			
			e.currentTarget.removeEventListener(DrainerEvent.READY, onDrainerReady);
			e.currentTarget.removeEventListener(DrainerEvent.ERROR, onDrainerError);
			
			dispatchEvent(new DrainerBuilderEvent(DrainerBuilderEvent.BUILD_ERROR));
		}
		
		public function stop():void
		{
			_inProgress = false;
			
			if (drainer)
			{
				drainer.removeEventListener(DrainerEvent.READY, onDrainerReady);
				drainer.removeEventListener(DrainerEvent.ERROR, onDrainerError);
				drainer.reset();
				
				addToCache(drainer);
			}
		}
		
		public function addToCache(item:Object):void
		{
			cahce.push(item);
		}
		
		public function get inProgress():Boolean
		{
			return _inProgress;
		}
	}
}