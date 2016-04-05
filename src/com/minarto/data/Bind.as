class com.minarto.data.Bind
{
	private var valueDic, reservations, handlerDic, uid:Number = 0;
	

	public function Bind()
	{
		valueDic = { };
		reservations = { };
		handlerDic = { };
	}
	
	
	public function set($key, $value):Void
	{
		valueDic[$key] = arguments.slice(1);
		
		evt.apply(this, arguments);
	}
	

	public function evt($key, $value):Void
	{
		var values:Array = arguments.slice(1), dic:Array = handlerDic[$key], i, a:Array;
		
		for(i in dic)
		{
			_set($key, values);
			return;
		}
		
		a = reservations[$key] || (reservations[$key] = [])
		a.push(values);
	}
		
		
	private function _set($key:String, $values:Array):Void
	{
		var dic:Array = handlerDic[$key], i, args:Array, func:Function;
		
		for(i in dic)
		{
			args = dic[i];
			func = args.handler;
			func.apply(args.scope, $values.concat(args));
		}
	}
	
	
	public function add($key:String, $scope, $handler:Function):Number
	{
		var dic:Array = handlerDic[$key] || (handlerDic[$key] = [] ), args:Array = arguments.slice(3), uid:Number = ++ uid;
		
		args.scope = $scope;
		args.handler = $handler;
		args.uid = uid;
		
		dic.push(args);
		
		delete	reservations[$key];
		
		return	uid;
	}
	
	
	public function addPlay($key:String, $scope, $handler:Function):Number
	{
		var uid:Number = add.apply(this, arguments), a:Array = reservations[$key], i:Number, l:Number = a ? a.length : 0, values:Array;
		
		if (l)
		{
			for (i = 0; i < l; ++i)
			{
				values = a[i];
				$handler.apply($scope, values.concat(arguments.slice(3)));
			}
		}
		else
		{
			values = valueDic[$key];
			if(values)
			{
				$handler.apply($scope, values.concat(arguments.slice(3)));
			}
		}		
		
		return	uid;
	}
		
	
	public function del($key:String, $scope, $handler:Function, $uid:Number):Void
	{
		var dic:Array = handlerDic[$key], i:Number, args:Array;
		
		if ($key)
		{
			if ($scope || $handler || $uid)
			{
				dic = handlerDic[$key];
				i = dic.length;
				if ($uid)
				{
					while(i--)
					{
						args = dic[i];
						if (args.uid == $uid)
						{
							dic.splice(i, 1);
						}
					}
				}
				else if ($scope && $handler)
				{
					while(i--)
					{
						args = dic[i];
						if (args.scope == $scope && args.handler == $handler)
						{
							dic.splice(i, 1);
						}
					}
				}
				else if($handler)
				{
					while(i--)
					{
						args = dic[i];
						if (args.handler == $handler)
						{
							dic.splice(i, 1);
						}
					}
				}
				else
				{
					while(i--)
					{
						args = dic[i];
						if (args.scope == $scope)
						{
							dic.splice(i, 1);
						}
					}
				}
			}
			else
			{
				delete	handlerDic[$key];
			}
		}
		else
		{
			if ($scope || $handler || $uid)
			{
				for ($key in handlerDic)
				{
					dic = handlerDic[$key];
					i = dic.length;
					if ($uid)
					{
						while(i--)
						{
							args = dic[i];
							if (args.uid == $uid)
							{
								dic.splice(i, 1);
							}
						}
					}
					else if ($scope && $handler)
					{
						while(i--)
						{
							args = dic[i];
							if (args.scope == $scope && args.handler == $handler)
							{
								dic.splice(i, 1);
							}
						}
					}
					else if($handler)
					{
						while(i--)
						{
							args = dic[i];
							if (args.handler == $handler)
							{
								dic.splice(i, 1);
							}
						}
					}
					else
					{
						while(i--)
						{
							args = dic[i];
							if (args.scope == $scope)
							{
								dic.splice(i, 1);
							}
						}
					}
				}			
			}
			else
			{
				handlerDic = {};
			}
		}		
	}
		
		
	public function getAt($key:String, $index:Number)
	{
		var values:Array = valueDic[$key];
		
		return	values ? values[$index || 0] : undefined;
	}
		
		
	public function get($key:String):Array
	{
		return	valueDic[$key];
	}
}
