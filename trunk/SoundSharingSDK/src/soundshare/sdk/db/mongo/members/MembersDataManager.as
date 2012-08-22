package soundshare.sdk.db.mongo.members
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import socket.json.JSONFacade;
	
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	
	public class MembersDataManager extends EventDispatcher
	{
		public static var GLOBAL_URL:String;
		
		public var url:String;
		public var token:String;
		public var collection:String;
		
		public function MembersDataManager(url:String=null, token:String=null)
		{
			this.url = url;
			this.token = token;
			this.collection = "members";
		}
		
		public function getMembersList(accountId:String, page:int = 1, itemsPerPage:int = 10):void
		{
			var urlString:String = fullUrl + "/" + accountId + "/" + page + "/" + itemsPerPage;
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			
			trace("-jointToGroup-", urlString);
			
			var urlLoader:URLLoader = addListeners(
				new URLLoader(),
				onMembersListComplete,
				onMembersListPregress,
				onMembersListSecurityError,
				onMembersListIOError
			);
			
			urlLoader.load(urlRequest);
		}
		
		private function onMembersListComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onMembersListComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			removeListeners(e.currentTarget, onMembersListComplete, onMembersListPregress, onMembersListSecurityError, onMembersListIOError);
		}
		
		private function onMembersListPregress(e:ProgressEvent):void 
		{
			trace("-onMembersListPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onMembersListSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onMembersListSecurityError-");
			
			removeListeners(e.currentTarget, onMembersListComplete, onMembersListPregress, onMembersListSecurityError, onMembersListIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onMembersListIOError(e:IOErrorEvent):void 
		{
			trace("-onMembersListIOError-");
			
			removeListeners(e.currentTarget, onMembersListComplete, onMembersListPregress, onMembersListSecurityError, onMembersListIOError);
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