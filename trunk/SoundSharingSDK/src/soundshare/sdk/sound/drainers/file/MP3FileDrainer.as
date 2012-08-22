package soundshare.sdk.sound.drainers.file
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import soundshare.sdk.sound.drainers.ISoundDrainer;
	import soundshare.sdk.sound.drainers.events.DrainerEvent;
	
	public class MP3FileDrainer extends EventDispatcher implements ISoundDrainer
	{
		private var soundSource:Sound;
		
		private var id3:ID3Info = new ID3Info();
		
		private var inProgress:Boolean = false;
		
		public function MP3FileDrainer()
		{
			super();
		}
		
		public function load(mediaData:Object):void
		{
			if (soundSource)
				reset();
			
			inProgress = true;
			
			soundSource = new Sound();
			soundSource.addEventListener(Event.COMPLETE, onSoundComplete);
			soundSource.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			soundSource.addEventListener(Event.ID3, onID3);
			soundSource.load(new URLRequest(mediaData.path));
		}
		
		private function ioErrorHandler(event:Event):void 
		{
			inProgress = false;
			
			soundSource.removeEventListener(Event.COMPLETE, onSoundComplete);
			soundSource.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			soundSource.removeEventListener(Event.ID3, onID3);
			
			dispatchEvent(new DrainerEvent(DrainerEvent.ERROR));
		}
		
		private function onSoundComplete(e:Event):void
		{
			trace("-onSoundComplete-");
			
			inProgress = false;
			
			soundSource.removeEventListener(Event.COMPLETE, onSoundComplete);
			soundSource.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			soundSource.removeEventListener(Event.ID3, onID3);
			
			var event:DrainerEvent = new DrainerEvent(DrainerEvent.READY);
			dispatchEvent(event);
		}
		
		private function onID3(e:Event):void
		{
			trace("-onID3-");
			
			id3 = (e.currentTarget as Sound).id3;
		}
		
		public function drain(block:uint, target:ByteArray):int
		{
			if (inProgress)
				return -1;
			
			var total:int = 0;
			
			if (target.length == 0)
				total = soundSource.extract(target, block);
			else
			{
				var b:ByteArray = new ByteArray();
				total = soundSource.extract(b, block);
				
				target.writeBytes(b);
			}
			
			/*if (total == 0 || total < block)
				_empty = true;*/
			
			return total;
		}
		
		public function reset():void
		{
			if (soundSource)
			{
				if (inProgress)
					soundSource.close();
				
				soundSource.removeEventListener(Event.COMPLETE, onSoundComplete);
				soundSource.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				soundSource.removeEventListener(Event.ID3, onID3);
				soundSource = null;
			}
			
			id3 = null;
			inProgress = false;
		}
		
		public function get audioInfoData():Object
		{
			var data:Object = {
				xtype: "ID3",
				data: id3
			};
			
			return data; 
		}
	}
}