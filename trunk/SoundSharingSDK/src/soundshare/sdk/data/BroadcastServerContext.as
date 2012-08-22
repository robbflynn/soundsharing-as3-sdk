package soundshare.sdk.data
{
	import soundshare.sdk.builders.managers.connections.server.ConnectionsManagerBuilder;
	import soundshare.sdk.builders.managers.plugins.PluginsManagersBuilder;
	import soundshare.sdk.builders.managers.plugins.ServerPluginsManagersBuilder;
	import soundshare.sdk.controllers.connection.client.ClientConnection;

	public class BroadcastServerContext
	{
		private var _token:String;
		
		public var connection:ClientConnection;
		public var connectionsManagerBuilder:ConnectionsManagerBuilder;
		
		public var pluginsManagersBuilder:ServerPluginsManagersBuilder;
		
		public function BroadcastServerContext()
		{
			connectionsManagerBuilder = new ConnectionsManagerBuilder(this);
			pluginsManagersBuilder = new ServerPluginsManagersBuilder(this);
		}
		
		public function set token(value:String):void
		{
			_token = value;
		}
		
		public function get token():String
		{
			return _token;
		}
	}
}