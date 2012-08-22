package soundshare.sdk.builders.managers.connections.server
{
	import soundshare.sdk.data.BroadcastServerContext;
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.connections.server.ConnectionsManager;

	public class ConnectionsManagerBuilder
	{
		protected var cache:Vector.<ConnectionsManager> = new Vector.<ConnectionsManager>();
		
		public var context:BroadcastServerContext;
		public var cacheEnabled:Boolean = true;
		
		public function ConnectionsManagerBuilder(context:BroadcastServerContext = null)
		{
			this.context = context;
		}
		
		public function build():ConnectionsManager
		{
			var manager:ConnectionsManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new ConnectionsManager();
			
			manager.receiverNamespace = "socket.managers.ConnectionsManager";
			manager.token = context.token;
			
			context.connection.addUnit(manager);
			
			return manager;
		}
		
		public function destroy(manager:ConnectionsManager):void
		{
			context.connection.removeUnit(manager.id);
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}