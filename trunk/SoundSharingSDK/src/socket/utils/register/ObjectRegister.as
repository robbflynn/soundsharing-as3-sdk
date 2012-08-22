package socket.utils.register
{
	public class ObjectRegister
	{
		public var collection:Array;
		public var obj:Object;
		public var name:String;
		public var total:int;
		public var parent:ObjectRegister;
		
		public function ObjectRegister(name:String = null, parent:ObjectRegister = null)
		{
			this.collection = new Array();
			this.name = name;
			this.obj = null;
			this.total = 0;
			this.parent = parent;
		}
		
		public function read(route:Array):Object
		{
			if (!route || route.length == 0)
				throw new Error("Invalid route parameter!");
			
			var cursor:ObjectRegister = this;
			
			for (var i:int = 0;i < route.length;i ++)
				if (cursor.collection[route[i]])
					cursor = cursor.collection[route[i]];
				else
					return null;
			
			return cursor.obj;
		}
		
		public function exist(route:Array):Boolean
		{
			if (!route || route.length == 0)
				throw new Error("Invalid route parameter!");
			
			var cursor:ObjectRegister = this;
			
			for (var i:int = 0;i < route.length;i ++)
				if (cursor.collection[route[i]])
					cursor = cursor.collection[route[i]];
				else
					return false;
			
			return true;
		}
		
		public function buildMap(route:Array, excludePath:int = 0, distinct:Boolean = false):Array
		{
			var map:Array = new Array();
			
			if (!excludePath)
				excludePath = 0;
			
			readMap(map, [], route, excludePath, distinct);
			
			if (map.length == 0)
				return null;
			
			return map;
		};
		
		public function readMap(map:Array, route1:Array, route2:Array, excludePath:int, distinct:Boolean):void
		{
			var cursor:ObjectRegister = this;
			var n:String;
			
			route1 = [].concat(route1);
			route2 = [].concat(route2);
			
			while (route2.length > 0 && route2[0] != "*")
			{
				n = route2.shift();
				route1.push(n);
				
				if (cursor.collection[n])
					cursor = cursor.collection[n];
				else
					return ;
			}
			
			if (cursor.obj && route1.length >= excludePath)
			{
				var r:Array = [].concat(route1);
				
				if (excludePath > 0)
					r.splice(0, excludePath);
				
				if (!distinct)
					map.push(r);
				else
				if (!cursor.routeExist(map, r))
					map.push(r);
			}
			
			if (cursor.total > 0 && (route2.length == 0 || route2[0] == "*"))
			{
				if (route2[0] == "*")
					route2.shift();
				
				var p:Array;
				
				for (var s:String in cursor.collection)
				{
					p = route1.concat([s]);
					cursor.collection[s].readMap(map, p, route2, excludePath, distinct);
				}
			}
		}
		
		private function routeExist(routes:Array, route:Array):Boolean
		{
			if (routes.length == 0)
				return false;
			
			var exist:Boolean;
			
			for (var i:int = 0;i < routes.length;i ++)
				if (routes[i].length == route.length)
				{
					exist = true;
					
					for (var k:int = 0;k < routes[i].length;k ++)
						if (routes[i][k] != route[k])
						{
							exist = false;
							break;
						}
					
					if (exist)
						return true;
				}
			
			return false;
		}
		
		public function buildObjectsMap(route:Array, excludePath:Array = null):Array
		{
			var map:Array = new Array();
			var cursor:ObjectRegister = this;
			var i:int;
			
			route = route ? route : [];
			
			if (route.length > 0)
			{
				for (i = 0;i < route.length;i ++)
					if (cursor.collection[route[i]])
						cursor = cursor.collection[route[i]];
					else
						return null;
			}
			
			if (excludePath && excludePath.length > 0)
				for (i = 0;i < excludePath.length;i ++) 
					if (route[0] == excludePath[0])
					{
						route.shift();
						excludePath.shift();
					}
					else
						break;
			
			if (cursor.obj && route.length > 0)
				map.push(route);
			
			if (cursor.total > 0)
				cursor.readObjectsMap(cursor, map, route);
			
			if (map.length == 0)
				return null;
			
			return map;
		}
		
		private function readObjectsMap(cursor:ObjectRegister, map:Array, route:Array):void
		{
			if (cursor.total > 0)
				for (var s:String in cursor.collection)
				{
					var p:Array = route.concat([s]);
					
					if (cursor.collection[s].obj)
						map.push({
							route: p,
							obj: cursor.collection[s].obj
						});
					
					if (cursor.collection[s].total > 0)
						cursor.collection[s].readObjectsMap(cursor.collection[s], map, p);
				}
		}
		
		public function register(route:Array, obj:Object):void
		{
			if (!route || !obj)
				throw new Error("Invalid route parameter!");
			
			
			var cursor:ObjectRegister = this;
			
			for (var i:int = 0;i < route.length;i ++)
			{
				if (!cursor.collection[route[i]])
				{
					cursor.collection[route[i]] = new ObjectRegister(route[i], cursor);
					cursor.total ++;
				}
				
				parent = cursor;
				cursor = cursor.collection[route[i]];
			}
			
			cursor.obj = obj;
		}
		
		public function unregister(route:Array):Boolean
		{
			if (!route)
				throw new Error("Invalid route parameter!");
			
			var cursor:ObjectRegister = this;
			var i:int;
			
			for (i = 0;i < route.length;i ++)
				if (cursor.collection[route[i]])
					cursor = cursor.collection[route[i]];
				else
					return false;
			
			cursor.obj = null;
			
			var executed:Boolean = false;
			var name:String;
			
			while (cursor.parent)
			{
				if (cursor.total == 0 && cursor.obj == null)
				{
					name = cursor.name;
					executed = true;
					
					cursor = cursor.parent;
					cursor.total --;
					
					delete(cursor.collection[name]);
				}
				else
					break;
			}
			
			return executed;
		}
		
		public function remove(route:Array):Boolean
		{
			if (!route)
				throw new Error("Invalid route parameter!");
			
			var cursor:ObjectRegister = this;
			var i:int;
			
			for (i = 0;i < route.length;i ++)
				if (cursor.collection[route[i]])
					cursor = cursor.collection[route[i]];
				else
					return false;
			
			var executed:Boolean = false;
			var name:String;
			
			if (cursor.parent)
			{
				name = cursor.name;
				executed = true;
				
				cursor = cursor.parent;
				cursor.total --;
				
				delete(cursor.collection[name]);
				
				while (cursor.parent)
				{
					if (cursor.total == 0 && cursor.obj == null)
					{
						name = cursor.name;
						
						cursor = cursor.parent;
						cursor.total --;
						
						delete(cursor.collection[name]);
					}
					else
						break;
				}
			}
			
			return executed;
		};
		
		public function removeByPattern(pattern:Array):Boolean
		{
			if (!pattern || pattern.length < 2 || pattern[0] != "*")
				throw new Error("Invalid pattern parameter!");
			
			var cursor:ObjectRegister = this;
			var allPart:Boolean = true;
			
			for (var i:int = 0;i < pattern.length;i ++)
			{
				if (allPart && pattern[i] != "*")
					allPart = false;
				else
				if (!allPart && pattern[i] == "*")
					return false;
			}
			
			executeRemoveByPattern(pattern);
			
			return true;
		};
		
		protected function executeRemoveByPattern(pattern:Array):void
		{
			if (pattern.length > 0)
			{
				if (pattern[0] == "*")
				{
					if (this.total > 0)
					{
						var p:Array = [].concat(pattern);
						p.shift();
						
						for (var s:String in this.collection)
							this.collection[s].executeRemoveByPattern(p);
					}
				}
				else
					remove(pattern);
			}
		};
		
		public function clear():void
		{
			collection = new Array(); 
			total = 0;
			obj = null;
		}
	}
}