package soundshare.sdk.sound.player.broadcast
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	public class BroadcastPlayer
	{
		private var samples:Vector.<ByteArray> = new Vector.<ByteArray>();
		
		private var soundFactory:Sound = new Sound();
		private var playing:Boolean = false;
		
		private var currentSample:ByteArray;
		
		private var _volume:Number = 1;
		
		public var minSamples:int = 15;
		
		public function BroadcastPlayer()
		{
			soundFactory = new Sound();
			soundFactory.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
		}
		
		public function process(stream:ByteArray):void
		{
			readSmapleData(stream);
			
			if (!playing && samples.length > minSamples)
			{
				playing = true;
				soundFactory.play();
			}
		}
		
		private function readSmapleData(rawData:ByteArray):void
		{
			while (rawData.bytesAvailable > 0)
			{
				if (!currentSample)
				{
					currentSample = new ByteArray();
					samples.push(currentSample);
				}
				
				var sampleBytesLeft:int = 32768 - currentSample.length;
				var b:ByteArray;
				
				if (sampleBytesLeft > rawData.bytesAvailable)
				{
					b = new ByteArray();
					rawData.readBytes(b, 0, rawData.bytesAvailable);
					
					currentSample.position = currentSample.length;
					currentSample.writeBytes(b);
				}
				else
				{
					b = new ByteArray();
					rawData.readBytes(b, 0, sampleBytesLeft);
					
					currentSample.position = currentSample.length;
					currentSample.writeBytes(b);
					
					currentSample = null;
				}
			}
		}
		
		private function onSampleData(e:SampleDataEvent):void
		{
			if (samples.length > 0)
			{
				var bytes:ByteArray = samples.shift() as ByteArray;
				
				if (volume == 1)
					e.data.writeBytes(bytes);
				else
				{
					bytes.position = 0;
					
					while (bytes.position != bytes.length)
						e.data.writeFloat(bytes.readFloat() * _volume);
				}
				
				if (samples.length == 0)
					playing = false;
			}
			else
				playing = false;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
	}
}