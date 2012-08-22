package soundshare.sdk.plugins.loaders.list
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import soundshare.sdk.plugins.container.IPluginContainer;
	import soundshare.sdk.plugins.loaders.list.events.PluginsListLoaderEvent;
	import soundshare.sdk.plugins.loaders.plugin.PluginLoader;
	import soundshare.sdk.plugins.loaders.plugin.events.PluginLoaderEvent;
	
	public class PluginsListLoader extends EventDispatcher
	{
		private var pendingPlugins:Vector.<PluginLoader> = new Vector.<PluginLoader>();
		private var _plugins:Vector.<IPluginContainer> = new Vector.<IPluginContainer>();
		
		public function PluginsListLoader()
		{
			super();
		}
		
		public function addPlugin(filename:String):void
		{
			var pl:PluginLoader = new PluginLoader();
			pl.url = filename;
			
			pendingPlugins.push(pl);
		}
		
		public function load():void
		{
			trace("PluginsListLoader[load]", pendingPlugins.length);
			
			if (pendingPlugins.length > 0)
				loadNext();
		}
		
		public function loadNext():void
		{
			trace("-PluginsListLoader[loadNext]-");
			
			var pl:PluginLoader = pendingPlugins.shift() as PluginLoader;
			pl.addEventListener(PluginLoaderEvent.COMPLETE, onPluginComplete);
			pl.addEventListener(PluginLoaderEvent.ERROR, onPluginError);
			pl.load();
		}
		
		protected function onPluginComplete(e:PluginLoaderEvent):void
		{
			trace("-PluginsListLoader[onPluginComplete]-");
			
			e.currentTarget.removeEventListener(PluginLoaderEvent.COMPLETE, onPluginComplete);
			e.currentTarget.removeEventListener(PluginLoaderEvent.ERROR, onPluginError);
			
			plugins.push(e.plugin);
			
			var event1:PluginsListLoaderEvent = new PluginsListLoaderEvent(PluginsListLoaderEvent.PLUGIN_COMPLETE);
			event1.plugin = e.plugin;
			event1.filename = (e.currentTarget as PluginLoader).url;
			
			dispatchEvent(event1);
			
			if (pendingPlugins.length > 0)
				loadNext();
			else
			{
				var event2:PluginsListLoaderEvent = new PluginsListLoaderEvent(PluginsListLoaderEvent.PLUGINS_COMPLETE);
				event2.plugins = plugins;
				
				dispatchEvent(event2);
			}
		}
		
		protected function onPluginError(e:PluginLoaderEvent):void
		{
			trace("-PluginsListLoader[onPluginError]-");
			
			e.currentTarget.removeEventListener(PluginLoaderEvent.COMPLETE, onPluginComplete);
			e.currentTarget.removeEventListener(PluginLoaderEvent.ERROR, onPluginError);
			
			dispatchEvent(new PluginsListLoaderEvent(PluginsListLoaderEvent.PLUGIN_ERROR));
			
			if (pendingPlugins.length > 0)
				loadNext();
			{
				if (plugins.length == 0)
					dispatchEvent(new PluginsListLoaderEvent(PluginsListLoaderEvent.PLUGINS_ERROR));
				else
				{
					var event:PluginsListLoaderEvent = new PluginsListLoaderEvent(PluginsListLoaderEvent.PLUGINS_COMPLETE);
					event.plugins = plugins;
					
					dispatchEvent(event);
				}
			}
		}
		
		public function reset():void
		{
			while (plugins.length > 0)
				plugins.shift();
			
			while (pendingPlugins.length > 0)
				pendingPlugins.shift();
		}
		
		public function get plugins():Vector.<IPluginContainer>
		{
			return _plugins;
		}
	}
}