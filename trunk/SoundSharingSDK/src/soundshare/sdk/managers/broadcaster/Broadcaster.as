package soundshare.sdk.managers.broadcaster
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	import soundshare.sdk.sound.channels.mixer.ChannelsMixer;
	
	public class Broadcaster extends SecureClientEventDispatcher
	{
		private var SAMPLE_RATE:Number = 44100;// 44,100 Hz sample rate.
		
		private var broadcastTimer:Timer;
		private var _broadcasting:Boolean = false;
		
		public var message:FlashSocketMessage;
		
		private var t:Number = 0;
		
		private var _channelsMixer:ChannelsMixer;
		
		public function Broadcaster()
		{
			super();
			
			this._channelsMixer = new ChannelsMixer();
			
			broadcastTimer = new Timer(100, 1);
			broadcastTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onBroadcast);
			//active = false;
		}
		
		public function start():void
		{
			if (!_broadcasting)
			{
				//active = true;
				_broadcasting = true;
				
				t = getTimer();
				broadcastTimer.start();
			}
		}
		
		public function stop():void
		{
			//active = false;
			_broadcasting = false;
			
			broadcastTimer.stop();
		}
		
		protected function onBroadcast(e:TimerEvent):void
		{
			var time:Number = getTimer() - t;
			t = getTimer();
			
			var block:uint = Math.ceil((time * SAMPLE_RATE) / 1000);
			
			channelsMixer.drain(block, message.$body);
			
			/*trace("1.onBroadcast:", message.$body.length);
			
			message.$body.compress();
			
			trace("2.onBroadcast:", message.$body.length, getTimer() - t);*/
			
			if (message.bodyLength > 0)
				send(message);
			
			broadcastTimer.start();
		}
		
		public function get broadcasting():Boolean
		{
			return _broadcasting;
		}
		
		public function get channelsMixer():ChannelsMixer
		{
			return _channelsMixer;
		}
	}
}