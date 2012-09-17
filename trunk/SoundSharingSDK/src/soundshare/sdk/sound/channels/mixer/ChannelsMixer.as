package soundshare.sdk.sound.channels.mixer
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import soundshare.sdk.sound.channels.base.SoundChannel;

	public class ChannelsMixer
	{
		private var channels:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		
		private var channelsByName:Array;
		private var namesByChannel:Dictionary;
		
		public var volume:Number = 1;
		
		public function ChannelsMixer()
		{
			channelsByName = new Array();
			namesByChannel = new Dictionary();
		}
		
		public function addChannel(channel:SoundChannel, name:String):void
		{
			if (!name)
				throw new Error("Channel name can't be null or empty!");
			
			channels.push(channel);
			
			channelsByName[name] = channel;
			namesByChannel[channel] = name;
		}
		
		public function removeChannel(channel:SoundChannel):void
		{
			if (!namesByChannel[channel])
				throw new Error("Channel does not exist!");
			
			var index:int = channels.indexOf(channel);
			channels.splice(index, 1);
			
			delete channelsByName[namesByChannel[channel]];
			delete namesByChannel[channel];
		}
		
		public function removeChannelByName(name:String):void
		{
			if (!channelsByName[name])
				throw new Error("Channel does not exist!");
			
			var index:int = channels.indexOf(channelsByName[name]);
			channels.splice(index, 1);
			
			delete namesByChannel[channelsByName[name]];
			delete channelsByName[name];
		}
		
		public function drain(size:int, buffer:ByteArray):void
		{
			buffer.clear();
			
			var len:int = channels.length;
			
			for (var i:int = 0;i < len;i ++) 
				channels[i].prepare(size);
			
			var value:Number;
			
			for (var j:int = 0; j < size * 2;j ++) 
			{
				value = 0;
				
				for (var k:int = 0;k < len; k++) 
					value += channels[k].readFloat();
				
				buffer.writeFloat(value * volume);
			}
		}
	}
}