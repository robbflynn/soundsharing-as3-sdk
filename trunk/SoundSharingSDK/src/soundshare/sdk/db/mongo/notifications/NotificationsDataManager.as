package soundshare.sdk.db.mongo.notifications
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
	
	import flashsocket.json.JSONFacade;
	
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	
	public class NotificationsDataManager extends EventDispatcher
	{
		public static var GLOBAL_URL:String;
		
		public var url:String;
		public var token:String;
		public var collection:String;
		
		public function NotificationsDataManager(url:String=null, token:String=null)
		{
			this.url = url;
			this.token = token;
			this.collection = "notifications";
		}
		
		// ******************************************************************************************************
		// 													REGISTER
		// ******************************************************************************************************
		
		public function joinToGroupRequest(sessionId:String, obj:Object):void
		{
			var urlString:String = fullUrl + "/jointogroup/" + sessionId;
			
			trace("-joinToGroupRequest-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.data = JSONFacade.stringify(obj);
			
			var urlLoader:URLLoader = addListeners(
				new URLLoader(),
				onJoinToGroupComplete,
				onJoinToGroupPregress,
				onJoinToGroupSecurityError,
				onJoinToGroupIOError
			);
			
			urlLoader.load(urlRequest);
		}
		
		private function onJoinToGroupComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onJoinToGroupComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			removeListeners(e.currentTarget, onJoinToGroupComplete, onJoinToGroupPregress, onJoinToGroupSecurityError, onJoinToGroupIOError);
		}
		
		private function onJoinToGroupPregress(e:ProgressEvent):void 
		{
			trace("-onJoinToGroupPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onJoinToGroupSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onJoinToGroupSecurityError-");
			
			removeListeners(e.currentTarget, onJoinToGroupComplete, onJoinToGroupPregress, onJoinToGroupSecurityError, onJoinToGroupIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onJoinToGroupIOError(e:IOErrorEvent):void 
		{
			trace("-onJoinToGroupIOError-");
			
			removeListeners(e.currentTarget, onJoinToGroupComplete, onJoinToGroupPregress, onJoinToGroupSecurityError, onJoinToGroupIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												
		// ******************************************************************************************************
		
		private function addListeners(target:Object, complete:Function, progress:Function, securityError:Function, IOError:Function):URLLoader
		{
			target.addEventListener(Event.COMPLETE, complete);
			target.addEventListener(ProgressEvent.PROGRESS, progress);
			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			target.addEventListener(IOErrorEvent.IO_ERROR, IOError);
			
			return target as URLLoader;
		}
		
		private function removeListeners(target:Object, complete:Function, progress:Function, securityError:Function, IOError:Function):void
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