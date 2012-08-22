package soundshare.sdk.builders.db.mongo.stations
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.stations.StationsDataManager;

	public class StationsDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<StationsDataManager> = new Vector.<StationsDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function StationsDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():StationsDataManager
		{
			var manager:StationsDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new StationsDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:StationsDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}