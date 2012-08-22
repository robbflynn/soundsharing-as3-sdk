package soundshare.sdk.builders.db.mongo.channels
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.channels.ChannelsDataManager;
	
	public class ChannelsDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<ChannelsDataManager> = new Vector.<ChannelsDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function ChannelsDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():ChannelsDataManager
		{
			var manager:ChannelsDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new ChannelsDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:ChannelsDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}