package soundshare.sdk.db.mongo.groups
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import socket.json.JSONFacade;
	
	import soundshare.sdk.db.mongo.base.MongoDBRest;
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	
	public class GroupsDataManager extends MongoDBRest
	{
		public function GroupsDataManager(url:String=null)
		{
			super(url, "groups");
		}
		
		// ******************************************************************************************************
		// 													JOIN
		// ******************************************************************************************************
		
		public function jointToGroup(notificationId:String):void
		{
			var urlString:String = fullUrl + "/join/" + notificationId;
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			//urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			//urlRequest.data = JSONFacade.stringify(obj);
			
			trace("-jointToGroup-", urlString);
			
			var urlLoader:URLLoader = addListeners(
				new URLLoader(),
				onJointToGroupComplete,
				onJointToGroupPregress,
				onJointToGroupSecurityError,
				onJointToGroupIOError
			);
			
			urlLoader.load(urlRequest);
		}
		
		private function onJointToGroupComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onJointToGroupComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			removeListeners(e.currentTarget, onJointToGroupComplete, onJointToGroupPregress, onJointToGroupSecurityError, onJointToGroupIOError);
		}
		
		private function onJointToGroupPregress(e:ProgressEvent):void 
		{
			trace("-onJointToGroupPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onJointToGroupSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onJointToGroupSecurityError-");
			
			removeListeners(e.currentTarget, onJointToGroupComplete, onJointToGroupPregress, onJointToGroupSecurityError, onJointToGroupIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onJointToGroupIOError(e:IOErrorEvent):void 
		{
			trace("-onJointToGroupIOError-");
			
			removeListeners(e.currentTarget, onJointToGroupComplete, onJointToGroupPregress, onJointToGroupSecurityError, onJointToGroupIOError);
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 													GET
		// ******************************************************************************************************
		
		public function getMembersList(groupId:String, page:int = 1, itemsPerPage:int = 10):void
		{
			var urlString:String = fullUrl + "/members/" + groupId + "/" + page + "/" + itemsPerPage;
			
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
	}
}