package soundshare.sdk.builders.managers.playlists.loader
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.playlists.loader.PlaylistsLoader;

	public class PlaylistsLoaderBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<PlaylistsLoader> = new Vector.<PlaylistsLoader>();
		
		public var cacheEnabled:Boolean = true;
		
		public function PlaylistsLoaderBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():PlaylistsLoader
		{
			var loader:PlaylistsLoader;
			
			if (cacheEnabled)
				loader = cache.shift();
			
			if (!loader)
				loader = new PlaylistsLoader();
			
			loader.context = context;
			
			return loader;
		}
		
		public function destroy(loader:PlaylistsLoader):void
		{
			loader.reset();
			
			if (cacheEnabled)
				cache.push(loader);
		}
	}
}