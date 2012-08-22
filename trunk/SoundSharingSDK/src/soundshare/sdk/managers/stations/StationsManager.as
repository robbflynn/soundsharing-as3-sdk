package soundshare.sdk.managers.stations
{
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.stations.StationsManagerMessageBuilder;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	import soundshare.sdk.managers.stations.events.StationsManagerEvent;
	
	public class StationsManager extends SecureClientEventDispatcher
	{
		private var messageBuilder:StationsManagerMessageBuilder;
		
		public function StationsManager()
		{
			super();
			
			messageBuilder = new StationsManagerMessageBuilder(this);
		}
		
		override protected function $dispatchSocketEvent(message:FlashSocketMessage):void
		{
			var event:Object = getActionData(message);
			
			if (event)
				dispatchEvent(new StationsManagerEvent(event.type, event.data));
		}
		
		public function stationUp(stationId:String):void
		{
			var message:FlashSocketMessage = messageBuilder.buildStationUpMessage(stationId);
			
			if (message)
				send(message);
		}
		
		public function stationDown(stationId:String):void
		{
			var message:FlashSocketMessage = messageBuilder.buildStationDownMessage(stationId);
			
			if (message)
				send(message);
		}
		
		public function shutDownStation(stationId:String):void
		{
			var message:FlashSocketMessage = messageBuilder.buildShutDownStationMessage(stationId);
			
			if (message)
				send(message);
		}
		
		public function startWatchStations(stations:Array, watchUp:Boolean = true, watchDown:Boolean = true):void
		{
			trace("startWatchStations:", id, route);
			
			var message:FlashSocketMessage = messageBuilder.buildStartWatchStations(stations, watchUp, watchDown);
			
			if (message)
				send(message);
		}
		
		public function stopWatchStations(stations:Array, watchUp:Boolean = true, watchDown:Boolean = true):void
		{
			var message:FlashSocketMessage = messageBuilder.buildStopWatchStations(stations, watchUp, watchDown);
			
			if (message)
				send(message);
		}
	}
}