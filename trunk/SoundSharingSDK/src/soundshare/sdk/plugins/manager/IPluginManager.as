package soundshare.sdk.plugins.manager
{
	import flash.events.IEventDispatcher;
	
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.data.plugin.PluginData;

	public interface IPluginManager extends IEventDispatcher
	{
		function prepare(data:Object = null):void
		function destroy(data:Object = null):void
			
		function match(data:Object):Object
			
		function set context(value:SoundShareContext):void
		function get context():SoundShareContext
			
		function set pluginData(value:PluginData):void
		function get pluginData():PluginData
	}
}