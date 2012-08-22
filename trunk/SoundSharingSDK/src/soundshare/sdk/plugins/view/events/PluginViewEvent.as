package soundshare.sdk.plugins.view.events
{
	import flash.events.Event;
	
	public class PluginViewEvent extends Event
	{
		public static const SHOWN:String = "shown";
		public static const HIDDEN:String = "hidden";
		
		public function PluginViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}