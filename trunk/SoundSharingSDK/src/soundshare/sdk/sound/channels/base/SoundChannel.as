package soundshare.sdk.sound.channels.base
{
	import flash.events.EventDispatcher;

	public class SoundChannel extends EventDispatcher
	{
		public var volume:Number = 1;
		
		public function SoundChannel()
		{
		}
		
		public function prepare(size:int):void
		{
		} 
		
		public function readFloat():Number
		{
			return 0 * volume;
		}
	}
}