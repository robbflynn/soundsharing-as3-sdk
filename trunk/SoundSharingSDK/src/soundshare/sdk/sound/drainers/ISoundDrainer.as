package soundshare.sdk.sound.drainers
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	public interface ISoundDrainer extends IEventDispatcher
	{
		function drain(block:uint, target:ByteArray):int;
		function load(mediaData:Object):void
		function reset():void
		
		function get audioInfoData():Object
	}
}