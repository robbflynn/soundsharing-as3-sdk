package soundshare.sdk.sound.drainers.events
{
	import flash.events.Event;
	
	public class DrainerEvent extends Event
	{
		public static const READY:String = "ready";
		public static const ERROR:String = "error";
		
		public function DrainerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}