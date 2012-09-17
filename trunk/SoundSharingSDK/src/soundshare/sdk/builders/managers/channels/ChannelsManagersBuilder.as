package soundshare.sdk.builders.managers.channels
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.channels.ChannelsManager;

	public class ChannelsManagersBuilder
	{
		protected var context:SoundShareContext;
		protected var cache:Vector.<ChannelsManager> = new Vector.<ChannelsManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function ChannelsManagersBuilder(context:SoundShareContext)
		{
			this.context = context;
		}
		
		public function build():ChannelsManager
		{
			trace("1.ChannelsManagersBuilder[build]:");
			
			var manager:ChannelsManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new ChannelsManager();
			
			manager.receiverNamespace = "socket.managers.ChannelsManager";
			manager.token = context.token;
			
			context.connection.addUnit(manager);
			
			trace("2.ChannelsManagersBuilder[build]:", manager.receiverRoute, manager.receiverNamespace);
			
			return manager;
		}
		
		public function destroy(manager:ChannelsManager):void
		{
			context.connection.removeUnit(manager.id);
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}