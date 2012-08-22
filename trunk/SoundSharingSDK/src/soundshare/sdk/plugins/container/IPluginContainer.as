package soundshare.sdk.plugins.container
{
	import mx.modules.IModule;
	
	import soundshare.sdk.plugins.builder.IPluginBuilder;

	public interface IPluginContainer extends IModule 
	{
		function get pluginBuilder():IPluginBuilder
	}
}