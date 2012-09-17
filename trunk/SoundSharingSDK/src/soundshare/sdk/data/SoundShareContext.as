package soundshare.sdk.data
{
	import soundshare.sdk.builders.context.BroadcastServerContextBuilder;
	import soundshare.sdk.builders.db.mongo.accounts.AccountsDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.channels.ChannelsDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.groups.GroupsDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.members.MembersDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.notifications.NotificationsDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.playlists.PlaylistsDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.servers.ServersDataManagersBuilder;
	import soundshare.sdk.builders.db.mongo.stations.StationsDataManagersBuilder;
	import soundshare.sdk.builders.managers.channels.ChannelsManagersBuilder;
	import soundshare.sdk.builders.managers.connections.manager.ConnectionsManagerBuilder;
	import soundshare.sdk.builders.managers.playlists.loader.PlaylistsLoaderBuilder;
	import soundshare.sdk.builders.managers.plugins.PluginsManagersBuilder;
	import soundshare.sdk.builders.managers.servers.ServersManagersBuilder;
	import soundshare.sdk.builders.managers.stations.StationsManagersBuilder;
	import soundshare.sdk.builders.plugins.PluginsBuilder;
	import soundshare.sdk.controllers.connection.client.ClientConnection;
	import soundshare.sdk.controllers.connections.ConnectionsController;
	import soundshare.sdk.managers.plugins.PluginsManager;
	import soundshare.sdk.plugins.collection.PluginsCollection;

	public class SoundShareContext
	{
		public var sessionId:String;
		private var _token:String;
		
		public var connection:ClientConnection;
		public var connectionsController:ConnectionsController;
		
		public var pluginsManager:PluginsManager;
		public var pluginsManagersBuilder:PluginsManagersBuilder;
		
		public var pluginsCollection:PluginsCollection;
		
		public var pluginsBuilder:PluginsBuilder;
		
		public var accountsDataManagersBuilder:AccountsDataManagersBuilder;
		public var groupsDataManagersBuilder:GroupsDataManagersBuilder;
		public var membersDataManagersBuilder:MembersDataManagersBuilder;
		public var channelsDataManagersBuilder:ChannelsDataManagersBuilder;
		public var playlistsDataManagersBuilder:PlaylistsDataManagersBuilder;
		public var notificationsDataManagersBuilder:NotificationsDataManagersBuilder;
		public var stationsDataManagersBuilder:StationsDataManagersBuilder;
		public var serversDataManagersBuilder:ServersDataManagersBuilder;
		
		public var playlistsLoaderBuilder:PlaylistsLoaderBuilder;
		
		
		public var channelsManagersBuilder:ChannelsManagersBuilder;
		public var stationsManagersBuilder:StationsManagersBuilder;
		public var serversManagersBuilder:ServersManagersBuilder;
		public var connectionsManagerBuilder:ConnectionsManagerBuilder;
		
		public var broadcastServerContextBuilder:BroadcastServerContextBuilder;
		
		public function SoundShareContext()
		{
			connectionsController = new ConnectionsController();
			connection = connectionsController.createConnection("MANAGER", true);
			
			pluginsCollection = new PluginsCollection();
			pluginsManagersBuilder = new PluginsManagersBuilder(this);
			
			pluginsManager = new PluginsManager();
			pluginsManager.namespace = "socket.managers.PluginsManager";
			
			connection.addUnit(pluginsManager);
			
			pluginsBuilder = new PluginsBuilder(this, pluginsCollection, pluginsManager);
			
			accountsDataManagersBuilder = new AccountsDataManagersBuilder();
			groupsDataManagersBuilder = new GroupsDataManagersBuilder(this);
			membersDataManagersBuilder = new MembersDataManagersBuilder(this);
			channelsDataManagersBuilder = new ChannelsDataManagersBuilder(this);
			playlistsDataManagersBuilder = new PlaylistsDataManagersBuilder(this);
			notificationsDataManagersBuilder = new NotificationsDataManagersBuilder(this);
			stationsDataManagersBuilder = new StationsDataManagersBuilder(this);
			serversDataManagersBuilder = new ServersDataManagersBuilder(this);
			
			playlistsLoaderBuilder = new PlaylistsLoaderBuilder(this);
			
			channelsManagersBuilder = new ChannelsManagersBuilder(this);
			stationsManagersBuilder = new StationsManagersBuilder(this);
			serversManagersBuilder = new ServersManagersBuilder(this);
			connectionsManagerBuilder = new ConnectionsManagerBuilder(this);
			
			broadcastServerContextBuilder = new BroadcastServerContextBuilder();
		}
		
		public function set token(value:String):void
		{
			_token = value;
			pluginsManager.token = value;
		}
		
		public function get token():String
		{
			return _token;
		}
	}
}