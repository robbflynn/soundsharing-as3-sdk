package soundshare.sdk.plugins.builder
{
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.data.plugin.PluginData;
	import soundshare.sdk.plugins.builder.result.PluginBuilderResult;
	import soundshare.sdk.plugins.manager.IPluginManager;

	public interface IPluginBuilder
	{
		function set context(value:SoundShareContext):void
		function get context():SoundShareContext
		
		function buildListener(pluginData:PluginData, buildView:Boolean = true, data:Object = null):PluginBuilderResult
		function buildBroadcaster(pluginData:PluginData, buildView:Boolean = true, data:Object = null):PluginBuilderResult
		function buildConfiguration(pluginData:PluginData, buildView:Boolean = true, data:Object = null):PluginBuilderResult
	}
}