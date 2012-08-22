package soundshare.sdk.builders.managers.plugins
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.plugins.PluginsManager;

	public class PluginsManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<PluginsManager> = new Vector.<PluginsManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function PluginsManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build(routingMap:Object):PluginsManager
		{
			var manager:PluginsManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new PluginsManager();
			
			manager.receiverNamespace = "socket.managers.PluginsManager";
			manager.token = context.token;
			
			manager.$identify(routingMap);
			
			context.connection.addUnit(manager);
			
			return manager;
		}
		
		public function destroy(manager:PluginsManager):void
		{
			context.connection.removeUnit(manager.id);
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}