package soundshare.sdk.builders.db.mongo.notifications
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.notifications.NotificationsDataManager;
	
	public class NotificationsDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<NotificationsDataManager> = new Vector.<NotificationsDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function NotificationsDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():NotificationsDataManager
		{
			var manager:NotificationsDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new NotificationsDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:NotificationsDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}