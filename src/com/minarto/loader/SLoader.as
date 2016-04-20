import com.minarto.loader.*;


class com.minarto.loader.SLoader extends MovieClipLoader
{
	static public function getInstance ():SLoader
	{
		var instance = new SLoader;
		
		getInstance = function()
		{
			return	instance;
		}
		return	getInstance();
	}
	
	
	private var reservations:Array, allVars, contents:Array, currentVars;
	
	
	public function SLoader()
	{
		reservations = [];
		contents = [];
		addListener(this);
	}
	
	
	private function onLoadInit ($target:MovieClip):Void
	{
		var key:String = "onComplete", fn:Function, fnParams:Array;
		
		contents.push($target);
		
		if (fn = currentVars[key])
		{
			if(fnParams = currentVars[key + "Params"])
			{
				fnParams.unshift($target);
			}
			else
			{
				fnParams = arguments;
			}
			fn.apply(currentVars[key + "Scope"], fnParams);
		}
		
		_load();
	}
	
	
	private function onLoadError ($target:MovieClip, $errorCode:String, $httpStatus:Number):Void
	{
		var key:String = "onError", fn:Function, fnParams:Array;
		
		contents.push($target);
		
		if (fn = currentVars[key])
		{
			if(fnParams = currentVars[key + "Params"])
			{
				fnParams.unshift($target, $errorCode, $httpStatus);
			}
			else
			{
				fnParams = arguments;
			}
			fn.apply(currentVars[key + "Scope"], fnParams);
		}
		
		_load();
	}

	
	public function add($target:MovieClip, $src:String):Void
	{
		del($target);
		reservations.push(arguments);
	}
	
	
	public function load($vars):Void
	{
		var key:String = "onProgress", fn:Function, fnParams:Array;
		
		if (!$vars)
		{
			$vars = { };
		}
		allVars = $vars;
		
		contents.length = 0;
		
		if (fn = $vars[key])
		{
			key += "Params";
			fnParams = $vars[key] || ($vars[key] = []);
			fnParams.unshift(0, 0);
		}
		
		if (!currentVars)
		{
			_load();
		}		
	}
	
	
	private function _load():Void
	{
		var target:MovieClip, key:String = "onProgress", fn:Function, fnParams:Array;
		
		if (fn = allVars[key = "onProgress"])
		{
			fnParams = allVars[key + "Params"];
			fnParams[0] = contents.length;
			fnParams[1] = reservations.length;
			fn.apply(allVars[key + "Scope"], fnParams);
		}
		
		if (currentVars = reservations.shift())
		{
			target = currentVars[0];
			unloadClip(target);
			loadClip(currentVars[1], target);
		}
		else
		{
			if (fn = allVars[key = "onComplete"])
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
			reservations.length = 0;
		}
	}
	
	
	public function del($target:MovieClip):Void
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
}
