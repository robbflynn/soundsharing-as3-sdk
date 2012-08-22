package soundshare.sdk.db.mongo.playlists.loader
{
	import flash.events.EventDispatcher;
	
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	import soundshare.sdk.db.mongo.playlists.PlaylistsDataManager;
	import soundshare.sdk.db.mongo.playlists.loader.events.PlaylistsLoaderEvent;
	
	public class PlaylistsLoader extends EventDispatcher
	{
		public var context:SoundShareContext;
		
		private var playlists:Array;
		private var loadedPlaylists:Array;
		
		private var tmpPlaylistsDataManager:PlaylistsDataManager;
		
		public function PlaylistsLoader(context:SoundShareContext = null)
		{
			this.context = context;
		}
		
		public function load(playlists:Array):void
		{
			if (!loadedPlaylists || loadedPlaylists.length > 0)
				loadedPlaylists = new Array();
			
			if (playlists)
				this.playlists = [].concat(playlists);
			
			if (this.playlists && this.playlists.length > 0)
			{
				tmpPlaylistsDataManager = context.playlistsDataManagersBuilder.build();
				
				tmpPlaylistsDataManager.addEventListener(MongoDBRestEvent.COMPLETE, onLoadPlaylistFileComplete);
				tmpPlaylistsDataManager.addEventListener(MongoDBRestEvent.ERROR, onLoadPlaylistFileError);
				
				loadNextPlaylist();
			}
		}
		
		public function reset():void
		{
			loadedPlaylists = new Array();
		}
		
		private function loadNextPlaylist():void
		{
			var id:String = playlists.shift() as String;
			
			tmpPlaylistsDataManager.loadPlaylistFile(id);
		}
		
		private function onLoadPlaylistFileComplete(e:MongoDBRestEvent):void
		{
			loadedPlaylists.push(e.data as Array);
			
			var event:PlaylistsLoaderEvent = new PlaylistsLoaderEvent(PlaylistsLoaderEvent.PLAYLIST_COMPLETE);
			event.playlists = loadedPlaylists;
			
			dispatchEvent(event);
			
			if (playlists.length > 0)
				loadNextPlaylist();
			else
			{
				tmpPlaylistsDataManager.removeEventListener(MongoDBRestEvent.COMPLETE, onLoadPlaylistFileComplete);
				tmpPlaylistsDataManager.removeEventListener(MongoDBRestEvent.ERROR, onLoadPlaylistFileError);
				
				context.playlistsDataManagersBuilder.destroy(tmpPlaylistsDataManager);
				tmpPlaylistsDataManager = null;
				
				event = new PlaylistsLoaderEvent(PlaylistsLoaderEvent.PLAYLISTS_COMPLETE);
				event.playlists = loadedPlaylists;
				
				dispatchEvent(event);
			}
		}
		
		private function onLoadPlaylistFileError(e:MongoDBRestEvent):void
		{
			dispatchEvent(new PlaylistsLoaderEvent(PlaylistsLoaderEvent.PLAYLIST_ERROR));
			
			if (playlists.length == 0)
			{
				tmpPlaylistsDataManager.removeEventListener(MongoDBRestEvent.COMPLETE, onLoadPlaylistFileComplete);
				tmpPlaylistsDataManager.removeEventListener(MongoDBRestEvent.ERROR, onLoadPlaylistFileError);
				
				context.playlistsDataManagersBuilder.destroy(tmpPlaylistsDataManager);
				tmpPlaylistsDataManager = null;
				
				if (loadedPlaylists.length == 0)
					dispatchEvent(new PlaylistsLoaderEvent(PlaylistsLoaderEvent.PLAYLISTS_ERROR));
				else
				{
					var event:PlaylistsLoaderEvent = new PlaylistsLoaderEvent(PlaylistsLoaderEvent.PLAYLISTS_COMPLETE);
					event.playlists = loadedPlaylists;
					
					dispatchEvent(event);
				}
			}
		}
	}
}