package soundshare.sdk.managers.plugins.request
{
	import flash.events.EventDispatcher;
	
	import soundshare.sdk.builders.plugins.PluginsBuilder;
	import soundshare.sdk.managers.plugins.PluginsManager;
	import soundshare.sdk.managers.plugins.request.events.PluginRequestEvent;
	import soundshare.sdk.plugins.builder.result.PluginBuilderResult;
	import soundshare.sdk.plugins.manager.events.PluginManagerEvent;
	
	public class PluginRequest extends EventDispatcher
	{
		public var _id:String;
		public var type:String;
		public var data:Object;
		public var sender:Array;
		public var pluginsBuilder:PluginsBuilder;
		
		private var _pluginBuilderResult:PluginBuilderResult;
		
		public function PluginRequest()
		{
			super();
		}
		
		public function process():void
		{
			switch (type)
			{
				case PluginsManager.BROADCASTER:
					_pluginBuilderResult = pluginsBuilder.buildBroadcaster(_id, false, data);
					
					if (!pluginBuilderResult.view && pluginBuilderResult.manager)
					{
						pluginBuilderResult.manager.addEventListener(PluginManagerEvent.READY, onPluginReady);
						pluginBuilderResult.manager.addEventListener(PluginManagerEvent.ERROR, onPluginError);
						pluginBuilderResult.manager.prepare(data);
					}
					else
					if (pluginBuilderResult.view)
						dispatchEvent(new PluginRequestEvent(PluginRequestEvent.COMPLETE));
					else
						dispatchEvent(new PluginRequestEvent(PluginRequestEvent.ERROR));
						
					break;
				case PluginsManager.LISTENER:
					break;
			}
		}
		
		private function onPluginReady(e:PluginManagerEvent):void
		{
			e.currentTarget.removeEventListener(PluginManagerEvent.READY, onPluginReady);
			e.currentTarget.removeEventListener(PluginManagerEvent.ERROR, onPluginError);
			
			dispatchEvent(new PluginRequestEvent(PluginRequestEvent.COMPLETE, e.data));
		}
		
		private function onPluginError(e:PluginManagerEvent):void
		{
			e.currentTarget.removeEventListener(PluginManagerEvent.READY, onPluginReady);
			e.currentTarget.removeEventListener(PluginManagerEvent.ERROR, onPluginError);
			
			dispatchEvent(new PluginRequestEvent(PluginRequestEvent.ERROR, null, e.error, e.code));
		}
		
		public function get pluginBuilderResult():PluginBuilderResult
		{
			return _pluginBuilderResult;
		}
	}
}