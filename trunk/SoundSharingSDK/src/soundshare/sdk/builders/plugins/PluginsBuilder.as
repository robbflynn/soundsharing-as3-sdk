package soundshare.sdk.builders.plugins
{
	import flash.events.Event;
	
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.data.plugin.PluginData;
	import soundshare.sdk.managers.plugins.PluginsManager;
	import soundshare.sdk.managers.plugins.events.PluginsManagerEvent;
	import soundshare.sdk.managers.plugins.request.PluginRequest;
	import soundshare.sdk.managers.plugins.request.events.PluginRequestEvent;
	import soundshare.sdk.plugins.builder.result.PluginBuilderResult;
	import soundshare.sdk.plugins.collection.PluginsCollection;
	import soundshare.sdk.plugins.manager.events.PluginManagerEvent;
	import soundshare.sdk.plugins.view.IPluginView;

	public class PluginsBuilder
	{
		private var context:SoundShareContext;
		private var pluginsCollection:PluginsCollection;
		private var pluginsManager:PluginsManager;
		
		public function PluginsBuilder(context:SoundShareContext, pluginsCollection:PluginsCollection, pluginsManager:PluginsManager)
		{
			this.context = context;
			this.pluginsCollection = pluginsCollection;
			
			this.pluginsManager = pluginsManager;
			this.pluginsManager.addEventListener(PluginsManagerEvent.PLUGIN_EXIST, onPluginExist);
			this.pluginsManager.addEventListener(PluginsManagerEvent.PLUGIN_REQUEST, onPluginRequest);
		}
		
		protected function onPluginExist(e:PluginsManagerEvent):void
		{
			var _id:String = e.data._id;
			var sender:Array = e.data.sender;
			
			var pd:PluginData = pluginsCollection.getPluginById(_id);
			
			if (pd)
				pluginsManager.dispatchPluginExistComplete(sender);
			else
				pluginsManager.dispatchPluginExistError(sender, "Plugin not exist!", 0);
		}
		
		protected function onPluginRequest(e:PluginsManagerEvent):void
		{
			trace("-PluginsBuilder[onPluginRequest]-");
			
			var pr:PluginRequest = new PluginRequest();
			pr._id = e.data._id;
			pr.type = e.data.type;
			pr.data = e.data.data;
			pr.sender = e.data.sender;
			pr.pluginsBuilder = this;
			pr.addEventListener(PluginRequestEvent.COMPLETE, onProcessComplete);
			pr.addEventListener(PluginRequestEvent.ERROR, onProcessError);
			pr.process();
		}
		
		protected function onProcessComplete(e:PluginRequestEvent):void
		{
			trace("-PluginsBuilder[onProcessComplete]-");
			
			e.currentTarget.removeEventListener(PluginRequestEvent.COMPLETE, onProcessComplete);
			e.currentTarget.removeEventListener(PluginRequestEvent.ERROR, onProcessError);
			
			pluginsManager.dispatchPluginRequestComplete((e.currentTarget as PluginRequest).sender, e.data);
		}
		
		protected function onProcessError(e:PluginRequestEvent):void
		{
			trace("-PluginsBuilder[onProcessError]-");
			
			e.currentTarget.removeEventListener(PluginRequestEvent.COMPLETE, onProcessComplete);
			e.currentTarget.removeEventListener(PluginRequestEvent.ERROR, onProcessError);
			
			var pr:PluginRequest = e.currentTarget as PluginRequest;
			
			pluginsManager.dispatchPluginRequestError(pr.sender, e.error, e.code);
		}
		
		public function buildListener(id:String, buildView:Boolean = true, data:Object = null):PluginBuilderResult
		{
			var pd:PluginData = pluginsCollection.getPluginById(id);
			pd.plugin.pluginBuilder.context = context;
			
			var pbr:PluginBuilderResult = pd.plugin.pluginBuilder.buildListener(pd, buildView, data);
			
			if (pbr.view)
				pbr.view.show();
			
			return pbr;
		}
		
		public function buildBroadcaster(id:String, buildView:Boolean = true, data:Object = null):PluginBuilderResult
		{
			var pd:PluginData = pluginsCollection.getPluginById(id);
			pd.plugin.pluginBuilder.context = context;
			
			var pbr:PluginBuilderResult = pd.plugin.pluginBuilder.buildBroadcaster(pd, buildView, data);
			
			if (pbr.view)
				pbr.view.show();
			
			return pbr;
		}
		
		public function buildConfiguration(id:String, buildView:Boolean = true, data:Object = null):PluginBuilderResult
		{
			var pd:PluginData = pluginsCollection.getPluginById(id);
			pd.plugin.pluginBuilder.context = context;
			
			var pbr:PluginBuilderResult = pd.plugin.pluginBuilder.buildConfiguration(pd, buildView, data);
			
			if (pbr.view)
				pbr.view.show();
			
			return pbr;
		}
	}
}