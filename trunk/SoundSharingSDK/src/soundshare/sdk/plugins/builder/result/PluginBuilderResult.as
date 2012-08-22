package soundshare.sdk.plugins.builder.result
{
	import soundshare.sdk.plugins.manager.IPluginManager;
	import soundshare.sdk.plugins.view.IPluginView;

	public class PluginBuilderResult
	{
		public var manager:IPluginManager;
		public var view:IPluginView;
		
		public function PluginBuilderResult(manager:IPluginManager = null, view:IPluginView = null)
		{
			this.manager = manager;
			this.view = view;
		}
	}
}