class com.minarto.data.Bind
{
	private var valueDic, reservations, handlerDic, uid:Number = 0;
	

	public function Bind()
	{
		valueDic = { };
		reservations = { };
		handlerDic = { };
	}
	
	
	public function set($key:String, $value):Void
	{
		valueDic[$key] = arguments.slice(1);
		
		evt.apply(this, arguments);
	}
	

	public function evt($key:String, $value):Void
	{
		var dic:Array = handlerDic[$key], i, args:Array, fn:Function;
		
		$value = arguments.slice(1);
		
		for(i in dic)
		{
			args = dic[i];
			fn = args.handler;
			fn.apply(args.scope, $value.concat(args));
		}
		
		if (!i)
		{
			args = reservations[$key] || (reservations[$key] = [])
			args.push($value);
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
		var a:Array = reservations[$key], uid:Number = add.apply(this, arguments), i:Number, l:Number = a ? a.length - 1 : 0, values:Array;
		
		for (i = 0; i < l; ++i)
		{
			values = a[i];
			$handler.apply($scope, values.concat(arguments.slice(3)));
		}
		
		if(values = valueDic[$key])
		{
			$handler.apply($scope, values.concat(arguments.slice(3)));
		}
		
		return	uid;
	}
		
	
	public function del($key:String, $scope, $handler:Function, $uid:Number):Void
	{
		var key:String, dic:Array, i:Number, args:Array;
		
		for (key in handlerDic)
		{
			if (($key == key) || (!$key))
			{
				dic = handlerDic[key];
				i = dic.length;
				while(i--)
				{
					args = dic[i];
					if ((($scope == args.scope) || (!$scope)) && (($handler == args.handler) || (!$handler)))
					{
						dic.splice(i, 1);
						continue;
					}
					if(($uid == args.uid) || (!$uid))
					{
						dic.splice(i, 1);
					}
				}
			}
		}
	}
		
		
	public function getAt($key:String, $index:Number)
	{
		var values:Array = valueDic[$key];
		
		return	values ? values[$index || 0] : values;
	}
		
		
	public function get($key:String):Array
	{
		return	valueDic[$key];
	}
}
