package soundshare.sdk.db.mongo.base
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flashsocket.json.JSONFacade;
	
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	
	public class MongoDBRest extends EventDispatcher
	{
		public static var GLOBAL_URL:String;
		
		public var url:String;
		public var token:String;
		public var collection:String;
		
		protected var insertLoader:URLLoader;
		protected var updateLoader:URLLoader;
		protected var deleteLoader:URLLoader;
		protected var listLoader:URLLoader;
		protected var getLoader:URLLoader;
		
		public function MongoDBRest(url:String = null, collection:String = null, token:String = null)
		{
			super();
			
			this.url = url;
			this.collection = collection;
			this.token = token;
		}
		
		// ******************************************************************************************************
		// 													INSERT
		// ******************************************************************************************************
		
		public function insertRecord(sessionId:String, obj:Object):void
		{
			var urlString:String = fullUrl + "/insert/" + sessionId;
			
			trace("-insertRecord-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.data = JSONFacade.stringify(obj);
			
			insertLoader = addListeners(
				new URLLoader(),
				onInsertComplete,
				onInsertPregress,
				onInsertSecurityError,
				onInsertIOError
			);
			
			insertLoader.load(urlRequest);
		}
		
		protected function onInsertComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onInsertComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR, result));
			
			insertLoader = null;
			removeListeners(e.currentTarget, onInsertComplete, onInsertPregress, onInsertSecurityError, onInsertIOError);
		}
		
		protected function onInsertPregress(e:ProgressEvent):void 
		{
			trace("-onInsertPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		protected function onInsertSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onInsertSecurityError-");
			
			insertLoader = null;
			removeListeners(e.currentTarget, onInsertComplete, onInsertPregress, onInsertSecurityError, onInsertIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		protected function onInsertIOError(e:IOErrorEvent):void 
		{
			trace("-onInsertIOError-");
			
			insertLoader = null;
			removeListeners(e.currentTarget, onInsertComplete, onInsertPregress, onInsertSecurityError, onInsertIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 													UPDATE
		// ******************************************************************************************************
		
		public function updateRecord(id:String, sessionId:String, obj:Object):void
		{
			var urlString:String = fullUrl + "/update/" + id + "/" + sessionId;
			
			trace("-updateRecord-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = JSONFacade.stringify(obj);
			
			updateLoader = addListeners(
				new URLLoader(),
				onUpdateComplete,
				onUpdatePregress,
				onUpdateSecurityError,
				onUpdateIOError
			);
			
			updateLoader.load(urlRequest);
		}
		
		protected function onUpdateComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onUpdateComplete-", event.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR, result));
			
			updateLoader = null;
			removeListeners(e.currentTarget, onUpdatePregress, onDeletePregress, onUpdateSecurityError, onUpdateIOError);
		}
		
		protected function onUpdatePregress(e:ProgressEvent):void 
		{
			trace("-onUpdatePregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		protected function onUpdateSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onUpdateSecurityError-");
			
			updateLoader = null;
			removeListeners(e.currentTarget, onUpdatePregress, onDeletePregress, onUpdateSecurityError, onUpdateIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		protected function onUpdateIOError(e:IOErrorEvent):void 
		{
			trace("-onUpdateIOError-");
			
			updateLoader = null;
			removeListeners(e.currentTarget, onUpdatePregress, onDeletePregress, onUpdateSecurityError, onUpdateIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 													DELETE
		// ******************************************************************************************************
		
		public function deleteRecord(sessionId:String, expression:Object = null):void
		{
			var urlString:String = fullUrl + "/delete/" + sessionId;
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.method = URLRequestMethod.POST;
			
			if (expression)
				urlRequest.data = JSONFacade.stringify(expression);
			
			trace("-deleteRecord-", urlString);
			
			deleteLoader = addListeners(
				new URLLoader(),
				onDeleteComplete,
				onDeletePregress,
				onDeleteSecurityError,
				onDeleteIOError
			);
			
			deleteLoader.load(urlRequest);
		}
		
		protected function onDeleteComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onDeleteComplete-", event.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR, result));
			
			deleteLoader = null;
			removeListeners(e.currentTarget, onDeleteComplete, onDeletePregress, onDeleteSecurityError, onDeleteIOError);
		}
		
		protected function onDeletePregress(e:ProgressEvent):void 
		{
			trace("-onDeletePregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		protected function onDeleteSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onDeleteSecurityError-");
			
			deleteLoader = null;
			removeListeners(e.currentTarget, onDeleteComplete, onDeletePregress, onDeleteSecurityError, onDeleteIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		protected function onDeleteIOError(e:IOErrorEvent):void 
		{
			trace("-onDeleteIOError-");
			
			deleteLoader = null;
			removeListeners(e.currentTarget, onDeleteComplete, onDeletePregress, onDeleteSecurityError, onDeleteIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												GET LIST
		// ******************************************************************************************************
		
		public function getRecordsList(expression:Object = null):void
		{
			var urlString:String = fullUrl + "/list"
			
			trace("-getRecords-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = JSONFacade.stringify(expression ? expression : {});
			
			listLoader = addListeners(
				new URLLoader(),
				onListComplete,
				onListPregress,
				onListSecurityError,
				onListIOError
			);
			
			listLoader.load(urlRequest);
		}
		
		protected function onListComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onListComplete-", event.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR, result));
			
			listLoader = null;
			removeListeners(e.currentTarget, onListComplete, onListPregress, onListSecurityError, onListIOError);
		}
		
		protected function onListPregress(e:ProgressEvent):void 
		{
			trace("-onListPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		protected function onListSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onListSecurityError-");
			
			listLoader = null;
			removeListeners(e.currentTarget, onListComplete, onListPregress, onListSecurityError, onListIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		protected function onListIOError(e:IOErrorEvent):void 
		{
			trace("-onListIOError-");
			
			listLoader = null;
			removeListeners(e.currentTarget, onListComplete, onListPregress, onListSecurityError, onListIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												GET RECORD
		// ******************************************************************************************************
		
		public function getRecord(expression:Object):void
		{
			var urlString:String = fullUrl + "/get";
			
			trace("-getRecord-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = JSONFacade.stringify(expression ? expression : {});
			
			getLoader = addListeners(
				new URLLoader(),
				onGetComplete,
				onGetPregress,
				onGetSecurityError,
				onGetIOError
			);
			
			getLoader.load(urlRequest);
		}
		
		protected function onGetComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onGetComplete-", event.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR, result));
			
			getLoader = null;
			removeListeners(e.currentTarget, onGetComplete, onGetPregress, onGetSecurityError, onGetIOError);
		}
		
		protected function onGetPregress(e:ProgressEvent):void 
		{
			trace("-onGetPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		protected function onGetSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onGetSecurityError-");
			
			getLoader = null;
			removeListeners(e.currentTarget, onGetComplete, onGetPregress, onGetSecurityError, onGetIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		protected function onGetIOError(e:IOErrorEvent):void 
		{
			trace("-onGetIOError-");
			
			getLoader = null;
			removeListeners(e.currentTarget, onGetComplete, onGetPregress, onGetSecurityError, onGetIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												
		// ******************************************************************************************************
		
		public function close():void
		{
			if (insertLoader)
			{
				removeListeners(insertLoader, onInsertComplete, onInsertPregress, onInsertSecurityError, onInsertIOError);
				
				insertLoader.close();
				insertLoader = null;
			}
			
			if (updateLoader)
			{
				removeListeners(updateLoader, onUpdatePregress, onDeletePregress, onUpdateSecurityError, onUpdateIOError);
				
				updateLoader.close();
				updateLoader = null;
			}
			
			if (deleteLoader)
			{
				removeListeners(deleteLoader, onDeleteComplete, onDeletePregress, onDeleteSecurityError, onDeleteIOError);
				
				deleteLoader.close();
				deleteLoader = null;
			}
			
			if (listLoader)
			{
				removeListeners(listLoader, onListComplete, onListPregress, onListSecurityError, onListIOError);
				
				listLoader.close();
				listLoader = null;
			}
			
			if (getLoader)
			{
				removeListeners(getLoader, onGetComplete, onGetPregress, onGetSecurityError, onGetIOError);
				
				getLoader.close();
				getLoader = null;
			}
		}
		
		// ******************************************************************************************************
		// 												
		// ******************************************************************************************************
		
		protected function addListeners(target:Object, complete:Function, progress:Function, securityError:Function, IOError:Function):URLLoader
		{
			target.addEventListener(Event.COMPLETE, complete);
			target.addEventListener(ProgressEvent.PROGRESS, progress);
			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			target.addEventListener(IOErrorEvent.IO_ERROR, IOError);
			
			return target as URLLoader;
		}
		
		protected function removeListeners(target:Object, complete:Function, progress:Function, securityError:Function, IOError:Function):void
		{
			target.removeEventListener(Event.COMPLETE, complete);
			target.removeEventListener(ProgressEvent.PROGRESS, progress);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			target.removeEventListener(IOErrorEvent.IO_ERROR, IOError);
		}
		
		// ******************************************************************************************************
		// 												
		// ******************************************************************************************************
		
		protected function get fullUrl():String
		{
			var u:String = url ? url : GLOBAL_URL;
			
			if (!token)
				return u + "/" + collection;
			
			return u + "/" + collection + "/" + token;
		}
	}
}