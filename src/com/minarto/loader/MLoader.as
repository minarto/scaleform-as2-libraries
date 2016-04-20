import com.minarto.loader.*;


class com.minarto.loader.MLoader extends MovieClipLoader
{
	static public function getInstance ():MLoader
	{
		var instance = new MLoader;
		
		getInstance = function()
		{
			return	instance;
		}
		return	getInstance();
	}
	
	
	private var reservations:Array, allVars, contents:Array;
	
	
	public function MLoader()
	{
		reservations = [];
		contents = [];
		addListener(this);
	}
	
	
	private function onLoadInit ($target:MovieClip):Void
	{
		var key:String = "onProgress", fn:Function = allVars[key], fnParams:Array, l:Number = contents.length, i:Number = l, args:Array, vars, j:Number;
		
		while ( i--)
		{
			args = contents[i];
			if (args[0] == $target)
			{
				contents[i] = $target;
				
				i = 0;
				j = l;
				while (j --)
				{
					if ((vars = contents[j]) instanceof MovieClip)
					{
						++ i;
					}
				}
				
				if (fn)
				{
					fnParams = allVars[key + "Params"];
					fnParams[0] = i;
					fnParams[1] = l;
					fn.apply(allVars[key + "Scope"], fnParams);
				}
				
				if ((vars = args[2]) && (fn = vars[key = "onComplete"]))
				{
					if (fnParams = vars[key + "Params"])
					{
						fnParams.unshift($target);
					}
					else
					{
						fnParams = arguments;
					}
					fn.apply(vars[key + "Scope"], fnParams);
				}
				
				if (i >= l)
				{
					onAllComplete();
				}
		
				return;
			}
		}
	}
	
	
	private function onLoadError ($target:MovieClip, $errorCode:String, $httpStatus:Number):Void
	{
		var key:String = "onProgress", fn:Function = allVars[key], fnParams:Array, l:Number = contents.length, i:Number = l, args:Array, vars, j:Number;
		
		while ( i--)
		{
			args = contents[i];
			if (args[0] == $target)
			{
				contents[i] = $target;
				
				i = 0;
				j = l;
				while (j --)
				{
					if ((vars = contents[j]) instanceof MovieClip)
					{
						++ i;
					}
				}
				
				if (fn)
				{
					fnParams = allVars[key + "Params"];
					fnParams[0] = i;
					fnParams[1] = l;
					fn.apply(allVars[key + "Scope"], fnParams);
				}
				
				if ((vars = args[2]) && (fn = vars[key = "onError"]))
				{
					if (fnParams = vars[key + "Params"])
					{
						fnParams.unshift($target);
					}
					else
					{
						fnParams = arguments;
					}
					fn.apply(vars[key + "Scope"], fnParams);
				}
				
				if (i >= l)
				{
					onAllComplete();
				}
		
				return;
			}
		}
	}
	
	
	private function onAllComplete ():Void
	{
		var key:String = "onComplete", fn:Function = allVars[key], fnParams:Array;
		
		if (fn)
		{
			if (fnParams = allVars[key + "Params"])
			{
				fnParams.unshift(contents.concat());
			}
			else
			{
				fnParams = [contents.concat()];
			}
			fn.apply(allVars[key + "Scope"], fnParams);
		}
		
		allVars = null;
		contents.length = 0;
	}
	
	
	public function add ($target:MovieClip, $src:String):Void
	{
		del($target);
		reservations.push(arguments);
	}
	
	
	public function del ($target:MovieClip):Void
	{
		var i:Number = reservations.length, args:Array;
		
		while ( i--)
		{
			args = reservations[i];
			if ((args[0] == $target) || (!$target))
			{
				reservations.splice(i, 1);
			}
		}
		
		i = contents.length;
		while ( i--)
		{
			args = contents[i];
			if ((args[0] == $target) || (!$target))
			{
				contents.splice(i, 1);
			}
		}
		
		if ($target)
		{
			unloadClip($target);
		}
	}
	
	
	public function load ($vars):Void
	{
		var key:String = "onProgress", fn:Function, fnParams:Array, i:Number = 0, l:Number = reservations.length, target:MovieClip;
		
		if (!$vars)
		{
			$vars = { };
		}
		allVars = $vars;
		
		if (fn = $vars[key])
		{
			fnParams = $vars[key + "Params"] || ($vars[key + "Params"] = []);
			fnParams.unshift(i, l);
			fn.apply($vars[key + "Scope"], fnParams);
		}
		
		for (i; i < l; ++i)
		{
			fnParams = reservations[i];
			
			contents.push(fnParams);
			
			target = fnParams[0];
			unloadClip(target);
			loadClip(fnParams[1], target);
		}
		
		reservations.length = 0;
	}
}
