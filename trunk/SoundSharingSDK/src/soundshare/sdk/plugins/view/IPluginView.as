package soundshare.sdk.plugins.view
{
	import soundshare.sdk.plugins.manager.IPluginManager;

	public interface IPluginView
	{
		function set manager(value:IPluginManager):void
		function get manager():IPluginManager
			
		function show():void
		function hide():void
	}
}