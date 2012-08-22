package soundshare.sdk.builders.managers.connections.manager
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.connections.manager.ConnectionsManager;

	public class ConnectionsManagerBuilder
	{
		static protected var cache:Vector.<ConnectionsManager> = new Vector.<ConnectionsManager>();
		
		protected var context:SoundShareContext;
		public var cacheEnabled:Boolean = true;
		
		public function ConnectionsManagerBuilder(context:SoundShareContext)
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