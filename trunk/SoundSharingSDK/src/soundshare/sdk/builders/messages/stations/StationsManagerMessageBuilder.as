package soundshare.sdk.builders.messages.stations
{
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;

	public class StationsManagerMessageBuilder
	{
		public var target:SecureClientEventDispatcher;
		
		public function StationsManagerMessageBuilder(target:SecureClientEventDispatcher)
		{
			this.target = target;
		}
		
		protected function build(xtype:String):FlashSocketMessage
		{
			if (!xtype)
				throw new Error("Invalid xtype!");
			
			var message:FlashSocketMessage = new FlashSocketMessage();
			message.setJSONHeader({
				route: {
					sender: target.route,
					receiver: target.receiverRoute
				},
				data: {
					token: target.token,
					action: {
						xtype: xtype
					}
				}
			});
			
			return message;
		}
		
		public function buildStationUpMessage(stationId:String):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("STATION_UP");
			message.setJSONBody({
				stationId: stationId
			});
			
			return message;
		}
		
		public function buildStationDownMessage(stationId:String):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("STATION_DOWN");
			message.setJSONBody({
				stationId: stationId
			});
			
			return message;
		}
		
		public function buildShutDownStationMessage(stationId:String):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("SHUT_DOWN_STATION");
			message.setJSONBody({
				stationId: stationId
			});
			
			return message;
		}
		
		public function buildStartWatchStations(stations:Array, watchUp:Boolean = true, watchDown:Boolean = true):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("START_WATCH");
			message.setJSONBody({
				stations: stations,
				up: watchUp,
				down: watchDown
			});
			
			return message;
		}
		
		public function buildStopWatchStations(stations:Array, watchUp:Boolean = true, watchDown:Boolean = true):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("STOP_WATCH");
			message.setJSONBody({
				stations: stations,
				up: watchUp,
				down: watchDown
			});
			
			return message;
		}
	}
}