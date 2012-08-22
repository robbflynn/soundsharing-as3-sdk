package soundshare.sdk.plugins.loaders.plugin
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.core.IFlexModuleFactory;
	
	import soundshare.sdk.plugins.container.IPluginContainer;
	import soundshare.sdk.plugins.loaders.plugin.events.PluginLoaderEvent;
	
	import spark.modules.Module;
	
	public class PluginLoader extends EventDispatcher
	{
		public var url:String;
		
		public function PluginLoader()
		{
			super();
		}
		
		public function load(url:String = null):void
		{
			this.url = url ? url : this.url;
			
			var urlRequest:URLRequest = new URLRequest(this.url);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoadingComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(urlRequest);
		}
		
		private function onLoadingComplete(e:Event): void 
		{
			var loader:URLLoader = URLLoader(e.target);
			var data:ByteArray = ByteArray(loader.data);
			
			var moduleLoader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			
			if (Capabilities.playerType == "Desktop")
				context.allowLoadBytesCodeExecution = true;
			
			context.applicationDomain = ApplicationDomain.currentDomain;    
			
			moduleLoader.loadBytes(data, context);
			moduleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadBytes);
		}
		
		private function onCompleteLoadBytes(e:Event): void 
		{
			var moduleLoader:LoaderInfo = LoaderInfo(e.target);
			
			if (moduleLoader.content is IFlexModuleFactory)
				moduleLoader.content.addEventListener("ready", onModuleReady);
			else
				dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.COMPLETE, moduleLoader.content as IPluginContainer));
		}
		
		private function onModuleReady(e:Event): void 
		{
			var factory:IFlexModuleFactory = IFlexModuleFactory(e.target);
			var module:Module = factory.create() as Module;
			
			dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.COMPLETE, module as IPluginContainer));
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.ERROR));
		}
	}
}