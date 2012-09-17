package soundshare.sdk.managers.channels
{
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.channels.ChannelsManagerMessageBuilder;
	import soundshare.sdk.managers.channels.events.ChannelsManagerEvent;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	
	public class ChannelsManager extends SecureClientEventDispatcher
	{
		private var messageBuilder:ChannelsManagerMessageBuilder;
		
		public function ChannelsManager()
		{
			super();
			
			messageBuilder = new ChannelsManagerMessageBuilder(this);
		}
		
		override protected function $dispatchSocketEvent(message:FlashSocketMessage):void
		{
			var event:Object = getActionData(message);
			
			if (event)
				dispatchEvent(new ChannelsManagerEvent(event.type, event.data));
		}
		
		public function startWatchChannels(channels:Array, watchUp:Boolean = true, watchDown:Boolean = true):void
		{
			trace("startWatchChannels:", id, route);
			
			var message:FlashSocketMessage = messageBuilder.buildStartWatchChannels(channels, watchUp, watchDown);
			
			if (message)
				send(message);
		}
		
		public function stopWatchChannels(channels:Array, watchUp:Boolean = true, watchDown:Boolean = true):void
		{
			var message:FlashSocketMessage = messageBuilder.buildStopWatchChannels(channels, watchUp, watchDown);
			
			if (message)
				send(message);
		}
	}
}