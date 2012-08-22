package soundshare.sdk.plugins.loaders.plugin.events
{
	import flash.events.Event;
	
	import soundshare.sdk.plugins.container.IPluginContainer;
	
	public class PluginLoaderEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		public var plugin:IPluginContainer;
		
		public function PluginLoaderEvent(type:String, plugin:IPluginContainer = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.plugin = plugin;
		}
	}
}