package soundshare.sdk.builders.managers.plugins
{
	import soundshare.sdk.data.BroadcastServerContext;
	import soundshare.sdk.managers.plugins.PluginsManager;

	public class ServerPluginsManagersBuilder
	{
		protected var context:BroadcastServerContext;
		protected var cache:Vector.<PluginsManager> = new Vector.<PluginsManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function ServerPluginsManagersBuilder(context:BroadcastServerContext)
		{
			this.context = context;
		}
		
		public function build():PluginsManager
		{
			var manager:PluginsManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new PluginsManager();
			
			manager.receiverNamespace = "socket.managers.PluginsManager";
			manager.token = context.token;
			
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