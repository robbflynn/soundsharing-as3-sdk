package soundshare.sdk.db.mongo.playlists
{
	import avmplus.getQualifiedClassName;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	import socket.json.JSONFacade;
	
	import soundshare.sdk.db.mongo.base.MongoDBRest;
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	
	public class PlaylistsDataManager extends MongoDBRest
	{
		public function PlaylistsDataManager(url:String=null)
		{
			super(url, "playlists");
		}
		
		// ******************************************************************************************************
		// 												SAVE PLAYLIST FILE
		// ******************************************************************************************************
		
		public function savePlaylistFile(id:Object, playlist:Array, sessionId:String):void
		{
			var urlString:String = fullUrl + "/save/" + id + "/" + playlist.length + "/" + sessionId;
			
			trace("-savePlaylistFile-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader('Content-type', 'application/octet-stream'));
			urlRequest.method = URLRequestMethod.POST;
			
			var ba:ByteArray = new ByteArray();
			ba.writeObject(playlist);
			ba.compress(CompressionAlgorithm.DEFLATE);
			
			urlRequest.data = ba;
			
			var urlLoader:URLLoader = addListeners(
				new URLLoader(),
				onSaveComplete,
				onSavePregress,
				onSaveSecurityError,
				onSaveIOError
			);
			
			urlLoader.load(urlRequest);
		}
		
		private function onSaveComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onSaveComplete-", event.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			removeListeners(e.currentTarget, onSaveComplete, onSavePregress, onSaveSecurityError, onSaveIOError);
		}
		
		private function onSavePregress(e:ProgressEvent):void 
		{
			trace("-onSavePregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onSaveSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onSaveSecurityError-");
			
			removeListeners(e.currentTarget, onSaveComplete, onSavePregress, onSaveSecurityError, onSaveIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onSaveIOError(e:IOErrorEvent):void 
		{
			trace("-onSaveIOError-");
			
			removeListeners(e.currentTarget, onSaveComplete, onSavePregress, onSaveSecurityError, onSaveIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												LOAD PLAYLIST FILE
		// ******************************************************************************************************
		
		public function loadPlaylistFile(id:Object):void
		{
			var urlString:String = fullUrl + "/load/" + id;
			
			trace("-loadPlaylistFile-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = addListeners(
				new URLLoader(),
				onLoadComplete,
				onLoadPregress,
				onLoadSecurityError,
				onLoadIOError
			);
			
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(urlRequest);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var ba:ByteArray = (e.currentTarget as URLLoader).data as ByteArray;
			var playlist:Array;
			
			trace("-PlaylistsDataManager[onLoadComplete]-", ba.length);
			
			try
			{
				ba.uncompress(CompressionAlgorithm.DEFLATE);
				playlist = ba.readObject() as Array;
			} 
			catch(error:Error) 
			{}
			
			if (playlist)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = playlist;
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			removeListeners(e.currentTarget, onLoadComplete, onLoadPregress, onLoadSecurityError, onLoadIOError);
		}
		
		private function onLoadPregress(e:ProgressEvent):void 
		{
			trace("-onLoadPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onLoadSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onLoadSecurityError-");
			
			removeListeners(e.currentTarget, onLoadComplete, onLoadPregress, onLoadSecurityError, onLoadIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onLoadIOError(e:IOErrorEvent):void 
		{
			trace("-onLoadIOError-");
			
			removeListeners(e.currentTarget, onLoadComplete, onLoadPregress, onLoadSecurityError, onLoadIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
	}
}