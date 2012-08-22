package soundshare.sdk.builders.db.mongo.groups
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.groups.GroupsDataManager;
	
	public class GroupsDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<GroupsDataManager> = new Vector.<GroupsDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function GroupsDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():GroupsDataManager
		{
			var manager:GroupsDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new GroupsDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:GroupsDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}