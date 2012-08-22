package soundshare.sdk.builders.sound.drainer.events
{
	import flash.events.Event;
	
	import soundshare.sdk.sound.drainers.ISoundDrainer;
	
	public class DrainerBuilderEvent extends Event
	{
		public static const BUILD_COMPLETE:String = "buildComplete";
		public static const BUILD_ERROR:String = "buildError";
		
		public var drainer:ISoundDrainer;
		
		public function DrainerBuilderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}