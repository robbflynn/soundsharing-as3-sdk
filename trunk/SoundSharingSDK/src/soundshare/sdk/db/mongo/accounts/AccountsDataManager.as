package soundshare.sdk.db.mongo.accounts
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
	import flash.utils.escapeMultiByte;
	
	import flashsocket.json.JSONFacade;
	
	import soundshare.sdk.db.mongo.base.MongoDBRest;
	import soundshare.sdk.db.mongo.base.events.MongoDBRestEvent;
	
	public class AccountsDataManager extends EventDispatcher
	{
		public static var GLOBAL_URL:String;
		
		public var url:String;
		public var collection:String;
		
		protected var registerUrlLoader:URLLoader;
		protected var loginUrlLoader:URLLoader;
		protected var logoutUrlLoader:URLLoader;
		protected var listUrlLoader:URLLoader;
		
		public function AccountsDataManager(url:String=null)
		{
			this.url = url;
			this.collection = "accounts";
		}
		
		// ******************************************************************************************************
		// 													REGISTER
		// ******************************************************************************************************
		
		public function register(obj:Object):void
		{
			trace("-register-");
			
			var u:String = url ? url : GLOBAL_URL;
			
			var urlRequest:URLRequest = new URLRequest(u + "/" + collection + "/register");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.data = JSONFacade.stringify(obj);
			
			registerUrlLoader = addListeners(
				new URLLoader(),
				onRegisterComplete,
				onRegisterPregress,
				onRegisterSecurityError,
				onRegisterIOError
			);
			
			registerUrlLoader.load(urlRequest);
		}
		
		private function onRegisterComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onRegisterComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			registerUrlLoader = null;
			removeListeners(e.currentTarget, onRegisterComplete, onRegisterPregress, onRegisterSecurityError, onRegisterIOError);
		}
		
		private function onRegisterPregress(e:ProgressEvent):void 
		{
			trace("-onRegisterPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onRegisterSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onRegisterSecurityError-");
			
			registerUrlLoader = null;
			removeListeners(e.currentTarget, onRegisterComplete, onRegisterPregress, onRegisterSecurityError, onRegisterIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onRegisterIOError(e:IOErrorEvent):void 
		{
			trace("-onRegisterIOError-");
			
			registerUrlLoader = null;
			removeListeners(e.currentTarget, onRegisterComplete, onRegisterPregress, onRegisterSecurityError, onRegisterIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 													LOGIN
		// ******************************************************************************************************
		
		public function login(username:String, password:String):void
		{
			var u:String = url ? url : GLOBAL_URL;
			
			username = escapeMultiByte(username);
			password = escapeMultiByte(password);
			
			var urlString:String = u + "/" + collection + "/login/" + username + "/" + password;
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = JSONFacade.stringify({});
			
			trace("-login-", urlString);
			
			loginUrlLoader = addListeners(
				new URLLoader(),
				onLoginComplete,
				onLoginPregress,
				onLoginSecurityError,
				onLoginIOError
			);
			
			loginUrlLoader.load(urlRequest);
		}
		
		private function onLoginComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onLoginComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR, result));
			
			loginUrlLoader = null;
			removeListeners(e.currentTarget, onLoginComplete, onLoginPregress, onLoginSecurityError, onLoginIOError);
		}
		
		private function onLoginPregress(e:ProgressEvent):void 
		{
			trace("-onLoginPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onLoginSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onLoginSecurityError-");
			
			loginUrlLoader = null;
			removeListeners(e.currentTarget, onLoginComplete, onLoginPregress, onLoginSecurityError, onLoginIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onLoginIOError(e:IOErrorEvent):void 
		{
			trace("-onLoginIOError-");
			
			loginUrlLoader = null;
			removeListeners(e.currentTarget, onLoginComplete, onLoginPregress, onLoginSecurityError, onLoginIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 													LOGIN
		// ******************************************************************************************************
		
		public function logout(id:String):void
		{
			var u:String = url ? url : GLOBAL_URL;
			var urlString:String = u + "/" + collection + "/logout/" + id;
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			
			trace("-logout-", urlString);
			
			logoutUrlLoader = addListeners(
				new URLLoader(),
				onLogoutComplete,
				onLogoutPregress,
				onLogoutSecurityError,
				onLogoutIOError
			);
			
			logoutUrlLoader.load(urlRequest);
		}
		
		private function onLogoutComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onLogoutComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			logoutUrlLoader = null;
			removeListeners(e.currentTarget, onLogoutComplete, onLogoutPregress, onLogoutSecurityError, onLogoutIOError);
		}
		
		private function onLogoutPregress(e:ProgressEvent):void 
		{
			trace("-onLogoutPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onLogoutSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onLogoutSecurityError-");
			
			logoutUrlLoader = null;
			removeListeners(e.currentTarget, onLogoutComplete, onLogoutPregress, onLogoutSecurityError, onLogoutIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onLogoutIOError(e:IOErrorEvent):void 
		{
			trace("-onLogoutIOError-");
			
			logoutUrlLoader = null;
			removeListeners(e.currentTarget, onLogoutComplete, onLogoutPregress, onLogoutSecurityError, onLogoutIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 											GET ACCOUNT DATA
		// ******************************************************************************************************
		
		protected var dataUrlLoader:URLLoader;
		
		public function getAccountData(id:String):void
		{
			var u:String = url ? url : GLOBAL_URL;
			var urlString:String = u + "/" + collection + "/data/" + id;
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.POST;
			
			trace("-getAccountData-", urlString);
			
			dataUrlLoader = addListeners(
				new URLLoader(),
				onGetDataComplete,
				onGetDataPregress,
				onGetDataSecurityError,
				onGetDataIOError
			);
			
			dataUrlLoader.load(urlRequest);
		}
		
		private function onGetDataComplete(e:Event):void 
		{
			var result:Object = JSONFacade.parse((e.currentTarget as URLLoader).data);
			
			if (!result.error)
			{
				var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.COMPLETE);
				event.data = result.data;
				
				trace("-onGetDataComplete-", result.data);
				
				dispatchEvent(event);
			}
			else
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			dataUrlLoader = null;
			removeListeners(e.currentTarget, onGetDataComplete, onGetDataPregress, onGetDataSecurityError, onGetDataIOError);
		}
		
		private function onGetDataPregress(e:ProgressEvent):void 
		{
			trace("-onGetDataPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onGetDataSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onGetDataSecurityError-");
			
			dataUrlLoader = null;
			removeListeners(e.currentTarget, onGetDataComplete, onGetDataPregress, onGetDataSecurityError, onGetDataIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onGetDataIOError(e:IOErrorEvent):void 
		{
			trace("-onGetDataIOError-");
			
			dataUrlLoader = null;
			removeListeners(e.currentTarget, onGetDataComplete, onGetDataPregress, onGetDataSecurityError, onGetDataIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												GET LIST
		// ******************************************************************************************************
		
		public function getRecordsList(expression:Object = null):void
		{
			var u:String = url ? url : GLOBAL_URL;
			var urlString:String = u + "/" + collection + "/list"
			
			trace("-getRecords-", urlString);
			
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			urlRequest.method = URLRequestMethod.POST;
			
			if (expression)
				urlRequest.data = JSONFacade.stringify(expression);
			
			listUrlLoader = addListeners(
				new URLLoader(),
				onListComplete,
				onListPregress,
				onListSecurityError,
				onListIOError
			);
			
			listUrlLoader.load(urlRequest);
		}
		
		private function onListComplete(e:Event):void 
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
				dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
			
			listUrlLoader = null;
			removeListeners(e.currentTarget, onListComplete, onListPregress, onListSecurityError, onListIOError);
		}
		
		private function onListPregress(e:ProgressEvent):void 
		{
			trace("-onListPregress-");
			
			var event:MongoDBRestEvent = new MongoDBRestEvent(MongoDBRestEvent.PROGRESS);
			event.bytesLoaded = e.bytesLoaded;
			event.bytesTotal = e.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function onListSecurityError(e:SecurityErrorEvent):void 
		{
			trace("-onListSecurityError-");
			
			listUrlLoader = null;
			removeListeners(e.currentTarget, onListComplete, onListPregress, onListSecurityError, onListIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		private function onListIOError(e:IOErrorEvent):void 
		{
			trace("-onListIOError-");
			
			listUrlLoader = null;
			removeListeners(e.currentTarget, onListComplete, onListPregress, onListSecurityError, onListIOError);
			
			dispatchEvent(new MongoDBRestEvent(MongoDBRestEvent.ERROR));
		}
		
		// ******************************************************************************************************
		// 												
		// ******************************************************************************************************
		
		public function close():void
		{
			if (registerUrlLoader)
			{
				removeListeners(registerUrlLoader, onRegisterComplete, onRegisterPregress, onRegisterSecurityError, onRegisterIOError);
				
				registerUrlLoader.close();
				registerUrlLoader = null;
			}
			
			if (loginUrlLoader)
			{
				removeListeners(loginUrlLoader, onLoginComplete, onLoginPregress, onLoginSecurityError, onLoginIOError);
				
				loginUrlLoader.close();
				loginUrlLoader = null;
			}
			
			if (logoutUrlLoader)
			{
				removeListeners(logoutUrlLoader, onLogoutComplete, onLogoutPregress, onLogoutSecurityError, onLogoutIOError);
				
				logoutUrlLoader.close();
				logoutUrlLoader = null;
			}
			
			if (dataUrlLoader)
			{
				removeListeners(dataUrlLoader, onGetDataComplete, onGetDataPregress, onGetDataSecurityError, onGetDataIOError);
				
				dataUrlLoader.close();
				dataUrlLoader = null;
			}
			
			if (listUrlLoader)
			{
				removeListeners(listUrlLoader, onListComplete, onListPregress, onListSecurityError, onListIOError);
				
				listUrlLoader.close();
				listUrlLoader = null;
			}
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
	}
}