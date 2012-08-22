package soundshare.sdk.builders.managers.stations
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.stations.StationsManager;

	public class StationsManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<StationsManager> = new Vector.<StationsManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function StationsManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():StationsManager
		{
			trace("1.StationsManagersBuilder[build]:");
			
			var manager:StationsManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new StationsManager();
			
			manager.receiverNamespace = "socket.managers.StationsManager";
			manager.token = context.token;
			
			context.connection.addUnit(manager);
			
			trace("2.StationsManagersBuilder[build]:", manager.receiverRoute, manager.receiverNamespace);
			
			return manager;
		}
		
		public function destroy(manager:StationsManager):void
		{
			context.connection.removeUnit(manager.id);
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}