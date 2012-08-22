package socket.client.base
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import socket.message.FlashSocketMessage;
	
	public class ClientSocketUnit extends EventDispatcher
	{
		private static var $id:int = 0;
		
		protected var _id:String;
		
		private var _route:Array = new Array();
		private var _receiverRoute:Array = new Array();
		
		protected var units:Vector.<ClientSocketUnit> = new Vector.<ClientSocketUnit>();
		protected var unitsById:Array = new Array();
		
		protected var _parent:ClientSocketUnit;
		protected var depth:int = 0;
		
		private var _online:Boolean = false;
		
		private var _namespace:String;
		private var _receiverNamespace:String;
		
		public function ClientSocketUnit(receiverRoute:Array = null)
		{
			super();
			
			this._id = generateId();
			this.receiverRoute = receiverRoute;
		}
		
		public function process(message:FlashSocketMessage):void
		{
			var receiver:Array = getMessageReceiver(message);
			
			if (receiver && depth < receiver.length)
			{
				var unitId:String = receiver[depth];
				
				if (id == unitId)
				{
					if (depth == receiver.length - 1)
						processActions(message);
					else
					{
						unitId = receiver[depth + 1];
						
						if (unitsById[unitId])
							unitsById[unitId].process(message);
					}
				}
			}
		}
		
		protected function processActions(message:FlashSocketMessage):Boolean
		{
			return false;
		}
		
		public function send(message:FlashSocketMessage):void
		{
			if (parent)
				parent.send(message);
		}
		
		public function getMessageReceiver(message:FlashSocketMessage):Array
		{
			var header:Object = message.getJSONHeader();
			
			return header && header.route ? header.route.receiver : null;
		}
		
		public function getMessageSender(message:FlashSocketMessage):Array
		{
			var header:Object = message.getJSONHeader();
			
			return header && header.route ? header.route.sender : null;
		}
		
		public function addUnit(unit:ClientSocketUnit):void
		{
			//trace("ClientSocketUnit[addUnit]: ", unit.id);
			
			unit.beforeAdd();
			
			units.push(unit);
			unitsById[unit.id] = unit;
			
			unit._parent = this;
			unit.afterAdd();
		}
		
		public function beforeAdd():void
		{
		}
		
		public function afterAdd():void
		{
			updateRoute();
			updateDepth();
			
			if (online)
			{
				register(true);
				identify(true);
			}
		}
		
		public function removeUnit(id:String):void
		{
			//trace("ClientSocketUnit[removeUnit]:", id);
			
			var index:int = units.indexOf(unitsById[id]);
			var unit:ClientSocketUnit = units[index];
			
			unit.beforeRemove();
			
			units.splice(index, 1);
			unitsById[id]._parent = null;
			
			delete unitsById[id];
			
			unit.afterRemove();
		}
		
		public function beforeRemove():void
		{
			if (online)
				unregister(true);
		}
		
		public function afterRemove():void
		{
		}
		
		public function getUnit(id:String):ClientSocketUnit
		{
			return unitsById[id];
		}
		
		public function updateRoute():void 
		{
			_route = parent ? parent.route.concat([id]) : [id];
			
			for (var i:int = 0; i < units.length;i ++)
				units[i].updateRoute();
		}
		
		public function updateDepth():void 
		{
			depth = parent ? parent.depth + 1 : 0;
			
			for (var i:int = 0; i < units.length;i ++)
				units[i].updateRoute();
		}
		
		public function identify(deep:Boolean = false):void
		{
			if (!deep && !receiverNamespace)
				return ;
			
			var remoteRoutingMap:Object = getRemoteRoutingMap();
			
			//trace("ClientSocketUnit[identify]:", id, deep, receiverNamespace, remoteRoutingMap);
			
			if (remoteRoutingMap)
			{
				if (deep)
					$identifyChildren(remoteRoutingMap);
				else
					$identify(remoteRoutingMap);
			}
		}
		
		public function identifyChildren():void
		{
			//trace("ClientSocketUnit[identifyChildren]");
			
			var remoteRoutingMap:Object = getRemoteRoutingMap();
			
			if (remoteRoutingMap)
				for (var i:int = 0; i < units.length;i ++)
					units[i].$identifyChildren(remoteRoutingMap);
		}
		
		public function $identify(remoteRoutingMap:Object):void
		{
			if (remoteRoutingMap && receiverNamespace && remoteRoutingMap.hasOwnProperty(receiverNamespace))
				receiverRoute = remoteRoutingMap[receiverNamespace];
		}
		
		public function $identifyChildren(remoteRoutingMap:Object):void
		{
			//trace("ClientSocketUnit[$identifyChildren]:", id, receiverNamespace, remoteRoutingMap);
			
			if (remoteRoutingMap)
			{
				var i:int;
				
				if (receiverNamespace && remoteRoutingMap.hasOwnProperty(receiverNamespace))
					receiverRoute = remoteRoutingMap[receiverNamespace];
				
				for (i = 0; i < units.length;i ++)
					units[i].$identifyChildren(remoteRoutingMap);
			}
		}
		
		public function remoteIdentify(target:ClientSocketUnit = null):void
		{
			//trace("ClientSocketUnit[remoteIdentify]");
			
			if (parent)
				parent.remoteIdentify(target ? target : this);
		}
		
		public function register(deep:Boolean = false):void
		{
			if (!deep && !namespace)
				return ;
			
			var localRoutingMap:Object = getLocalRoutingMap();
			
			//trace("ClientSocketUnit[register]:", id, deep, namespace, localRoutingMap);
			
			if (localRoutingMap)
			{
				if (deep)
					$registerChildren(localRoutingMap);
				else
				{
					if (localRoutingMap[namespace])
						throw new Error("Unit namespace already exist!");
					else
						localRoutingMap[namespace] = route;
				}
			}
		}
		
		public function registerChildren():void
		{
			var localRoutingMap:Object = getLocalRoutingMap();
			
			if (localRoutingMap)
				for (var i:int = 0; i < units.length;i ++)
					units[i].$registerChildren(localRoutingMap);
		}
		
		public function $registerChildren(localRoutingMap:Object):void
		{
			if (localRoutingMap)
			{
				if (namespace)
				{
					if (localRoutingMap[namespace])
						throw new Error("Unit namespace already exist!");
					else
						localRoutingMap[namespace] = route;
				}
				
				for (var i:int = 0; i < units.length;i ++)
					units[i].$registerChildren(localRoutingMap);
			}
		}
		
		public function unregister(deep:Boolean = false):void
		{
			if (!deep && !namespace)
				return ;
			
			var localRoutingMap:Object = getLocalRoutingMap();
			
			if (localRoutingMap)
			{
				if (deep)
					$unregisterChildren(localRoutingMap);
				else
				if (localRoutingMap[namespace])
					delete localRoutingMap[namespace];
			}
		}
		
		public function unregisterChildren():void
		{
			var localRoutingMap:Object = getLocalRoutingMap();
			
			if (localRoutingMap)
				for (var i:int = 0; i < units.length;i ++)
					units[i].$unregisterChildren(localRoutingMap);
		}
		
		public function $unregisterChildren(localRoutingMap:Object):void
		{
			if (localRoutingMap)
			{
				if (namespace && localRoutingMap[namespace])
					delete localRoutingMap[namespace];
				
				for (var i:int = 0; i < units.length;i ++)
					units[i].$unregisterChildren(localRoutingMap);
			}
		}
		
		public function getLocalRoutingMap():Object
		{
			return parent ? parent.getLocalRoutingMap() : null;
		}
		
		public function getRemoteRoutingMap():Object
		{
			return parent ? parent.getRemoteRoutingMap() : null;
		}
		
		public function connected():void
		{
			for (var i:int = 0; i < units.length;i ++)
				units[i].connected();
		}
		
		public function disconnected():void
		{
			for (var i:int = 0; i < units.length;i ++)
				units[i].disconnected();
		}
		
		protected function generateId():String
		{
			$id ++;
			return "SU." + $id + "." + Math.random().toString().substr(2);
		}
		
		public function set id(value:String):void
		{
			var p:ClientSocketUnit = parent;
			
			if (p)
			{
				p.removeUnit(_id);
				
				_id = value;
				p.addUnit(this);
			}
			else
			{
				_id = value;
				updateRoute();
			}
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get route():Array
		{
			return _route;
		}
		
		public function set receiverRoute(value:Array):void
		{
			_receiverRoute = value;
		}
		
		public function get receiverRoute():Array
		{
			return _receiverRoute;
		}
		
		public function get online():Boolean
		{
			if (!parent)
				return false;
			
			return parent.online;
		}
		
		public function set namespace(value:String):void
		{
			_namespace = value;
		}
		
		public function get namespace():String
		{
			return _namespace;
		}
		
		public function set receiverNamespace(value:String):void
		{
			_receiverNamespace = value;
		}
		
		public function get receiverNamespace():String
		{
			return _receiverNamespace;
		}
		
		public function get parent():ClientSocketUnit
		{
			return _parent;
		}
	}
}