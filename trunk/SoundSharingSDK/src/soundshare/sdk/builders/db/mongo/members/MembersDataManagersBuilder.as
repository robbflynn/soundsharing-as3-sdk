package soundshare.sdk.builders.db.mongo.members
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.members.MembersDataManager;

	public class MembersDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<MembersDataManager> = new Vector.<MembersDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function MembersDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():MembersDataManager
		{
			var manager:MembersDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new MembersDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:MembersDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}