package soundshare.sdk.builders.managers.servers
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.servers.ServersManager;

	public class ServersManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<ServersManager> = new Vector.<ServersManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function ServersManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():ServersManager
		{
			var manager:ServersManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new ServersManager();
			
			manager.receiverNamespace = "socket.managers.ServersManager";
			manager.token = context.token;
			
			context.connection.addUnit(manager);
			
			return manager;
		}
		
		public function destroy(manager:ServersManager):void
		{
			context.connection.removeUnit(manager.id);
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}