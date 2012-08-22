package soundshare.sdk.builders.db.mongo.playlists
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.playlists.PlaylistsDataManager;
	
	public class PlaylistsDataManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<PlaylistsDataManager> = new Vector.<PlaylistsDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function PlaylistsDataManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():PlaylistsDataManager
		{
			var manager:PlaylistsDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new PlaylistsDataManager();
			
			manager.token = context.token;
			
			return manager;
		}
		
		public function destroy(manager:PlaylistsDataManager):void
		{
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}