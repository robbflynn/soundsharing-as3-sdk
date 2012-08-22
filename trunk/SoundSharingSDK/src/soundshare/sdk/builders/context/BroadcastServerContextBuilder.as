package soundshare.sdk.builders.context
{
	import soundshare.sdk.builders.managers.connections.manager.ConnectionsManagerBuilder;
	import soundshare.sdk.data.BroadcastServerContext;
	
	public class BroadcastServerContextBuilder
	{
		protected var cache:Vector.<BroadcastServerContext> = new Vector.<BroadcastServerContext>();
		
		public var cacheEnabled:Boolean = true;
		
		public function BroadcastServerContextBuilder()
		{
		}
		
		public function build():BroadcastServerContext
		{
			var manager:BroadcastServerContext;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new BroadcastServerContext();
			
			return manager;
		}
		
		public function destroy(manager:BroadcastServerContext):void
		{
			manager.connection = null;
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}