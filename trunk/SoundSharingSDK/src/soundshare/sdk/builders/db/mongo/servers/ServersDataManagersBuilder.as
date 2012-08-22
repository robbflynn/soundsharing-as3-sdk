package soundshare.sdk.builders.db.mongo.servers
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.servers.ServersDataManager;

	public class ServersDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<ServersDataManager> = new Vector.<ServersDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function ServersDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():ServersDataManager
		{
			var manager:ServersDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new ServersDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:ServersDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}