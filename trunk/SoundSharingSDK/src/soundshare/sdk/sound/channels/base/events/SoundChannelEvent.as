package soundshare.sdk.sound.channels.base.events
{
	import flash.events.Event;
	
	public class SoundChannelEvent extends Event
	{
		public static const READY:String = "ready";
		
		public function SoundChannelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}