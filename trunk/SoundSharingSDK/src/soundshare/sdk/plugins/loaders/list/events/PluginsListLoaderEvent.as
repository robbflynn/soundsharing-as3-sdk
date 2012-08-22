package soundshare.sdk.plugins.loaders.list.events
{
	import flash.events.Event;
	
	import soundshare.sdk.plugins.container.IPluginContainer;
	
	public class PluginsListLoaderEvent extends Event
	{
		public static const PLUGINS_COMPLETE:String = "pluginsComplete";
		public static const PLUGINS_ERROR:String = "pluginsError";
		
		public static const PLUGIN_COMPLETE:String = "pluginComplete";
		public static const PLUGIN_ERROR:String = "pluginError";
		
		public var plugins:Vector.<IPluginContainer>;
		public var plugin:IPluginContainer;
		
		public var filename:String;
		
		public function PluginsListLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}