import com.minarto.data.*;
import gfx.controls.*;
import gfx.managers.FocusHandler;


class com.minarto.managers.KeyManager extends Bind
{
	static private var _enterKeyDown:String = "keyDown.13.false.false.false";
	
	/**
	 * singleton instance
	 * @return
	 */
	static public function getInstance():KeyManager
	{
		var instance = new KeyManager;
		getInstance = function()
		{
			return	instance;
		}
		return	getInstance();
	}	
	
	private var keyMap, _isEnable:Boolean = false, _lastDownKey:String, _isShift:Boolean = false, _isControl:Boolean = false, _isAlt:Boolean = false;
	
	public var repeat:Boolean;

	public function KeyManager()
	{
		keyMap = { };
		setEnable(true);
	}	
	
	public function setEnable($enable:Boolean):Void
	{
		if (_isEnable == $enable)
		{
			return;
		}
		
		_isEnable = $enable;
		if ($enable)
		{
			Key.addListener(this);
		}
		else
		{
			Key.removeListener(this);
		}
	}	

	public function getEnable():Boolean
	{
		return	_isEnable;
	}	

	private function onKeyDown ():Void
	{
		var f = FocusHandler.instance.getFocus(0), keyCode:Number, e;
		
		if (TextField(f) || TextInput(f) || TextArea(f))
		{
			return;
		}
		
		keyCode = Key.getCode();
		switch(keyCode)
		{
			case Key.SHIFT :
				_isShift = true;
				break;
			case Key.CONTROL :
				_isControl = true;
				break;
			case Key.ALT :
				_isAlt = true;
				break;
		}

		e = "keyDown." + keyCode + "." + _isControl + "." + _isAlt + "." + _isShift;
		
		if (!repeat && (_lastDownKey == e))
		{
			return;
		}
		
		if (f = keyMap[e])
		{
			e = { type:"keyDown", keyCode:keyCode, ctrlKey:_isControl, altKey:_isAlt, shiftKey:_isShift };
			this.set("lastKey", e);
			evt(f, e );
		}
		
		_lastDownKey = e;
	}		
		
	private function onKeyUp ():Void
	{
		var f = FocusHandler.instance.getFocus(0), keyCode:Number = Key.getCode(), e;
		
		switch(keyCode)
		{
			case Key.SHIFT :
				_isShift = false;
				break;
			case Key.CONTROL :
				_isControl = false;
				break;
			case Key.ALT :
				_isAlt = false;
				break;
		}
		
		e = "keyUp." + keyCode + "." + _isControl + "." + _isAlt + "." + _isShift;
		_lastDownKey = null;
		
		if ((TextField(f) || TextInput(f) || TextArea(f)) && (e != _enterKeyDown))	//	enter 예외
		{
			return;
		}
		
		if (f = keyMap[e])
		{
			e = { type:"keyUp", keyCode:keyCode, ctrlKey:_isControl, altKey:_isAlt, shiftKey:_isShift };
			this.set("lastKey", e);
			evt(f, e );
		}
	}	
	
	/**
	 * key setting
	 * @param	$keyBind
	 * @param	$type
	 * @param	$keyCode
	 * @param	$ctrlKey
	 * @param	$altKey
	 * @param	$shiftKey
	 */
	public function setKey($keyBind:String, $type:String, $keyCode:Number, $ctrlKey:Boolean, $altKey:Boolean, $shiftKey:Boolean):Void
	{
		var e:String = $type + "." + $keyCode + "." + Boolean($ctrlKey) + "." + Boolean($altKey) + "." + Boolean($shiftKey);
		
		if ($keyBind)
		{
			keyMap[e] = $keyBind;
		}
		else
		{
			delete	keyMap[e];
		}
	}	
	
	/**
	 * delete key setting
	 * @param	$keyBind
	 */
	public function delKey($keyBind:String):Void
	{
		var e:String;
		
		for (e in keyMap)
		{
			if (keyMap[e] == $keyBind)
			{
				delete	keyMap[e];
			}
		}
	}	
	
	public function getKey($keyBind:String):Array
	{
		var e:String, a:Array = [], a1:Array;
		
		for (e in keyMap)
		{
			if (keyMap[e] == $keyBind)
			{
				a1 = e.split(".");
				a.push({type:a1[0], keyCode:a1[1], ctrlKey:a1[2], altKey:a1[3], shiftKey:a1[4]});
			}
		}
		
		return	a;
	}
}
