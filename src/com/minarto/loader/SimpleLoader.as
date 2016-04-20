import com.minarto.loader.*;


class com.minarto.loader.SimpleLoader
{
	static private function _init():Void
	{
		var loader:MovieClipLoader = new MovieClipLoader, dic = {}, callee = arguments.callee;
		
		loader.addListener(callee);
		
		load = function($target:MovieClip, $src:String)
		{
			loader.unloadClip($target);
			
			dic[targetPath($target)] = arguments;
			
			loader.loadClip($src, $target);
		}
		
		unLoad = function($target:MovieClip)
		{
			loader.unloadClip($target);
			delete	dic[targetPath($target)];
		}
		
		callee.onLoadInit = function($target:MovieClip)
		{
			var path:String = targetPath($target), args:Array = dic[path], func:Function, scope;
			
			delete	dic[path];
			
			if (func = args[3])
			{
				scope = args[2];
				
				args = args.slice(4);
				args[0] = $target;
				
				func.apply(scope, args);
			}
		}		
		
		callee.onLoadError = function($target:MovieClip, $errorCode, $httpStatus)
		{
			var path:String = targetPath($target), args:Array = dic[path], func:Function, scope;
			
			delete	dic[path];
			
			if (func = args[4])
			{
				scope = args[2];
				
				args = args.slice(2);
				args[0] = $target;
				args[1] = $errorCode;
				args[2] = $httpStatus;
				
				func.apply(scope, args);
			}
		}
		
		delete	SimpleLoader._init;
	}
	
	
	static public function load($target:MovieClip, $src:String, $scope, $onComplete:Function, $onError:Function):Void
	{
		_init();
		load.apply(SimpleLoader, arguments);
	}
	
	
	static public function unLoad($target:MovieClip):Void
	{
		_init();
		unLoad($target);
	}
}
