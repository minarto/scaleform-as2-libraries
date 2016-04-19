import com.minarto.controls.*;
import com.minarto.constransts.InvalidationType;
import com.minarto.core.UIComponentX;
import gfx.controls.Button;


class com.minarto.controls.ButtonX extends Button
{
	public function toString():String
	{
		return "[com.minarto.controls.ButtonX: " + _name + "]";
	}
	

	private var _invalid:Boolean, _invalidHash = { };
	
	
	public function setSize($w:Number, $h:Number):Void
	{
		//super.setSize($w, $h);
		
		if (__width == $w && __height == $h)	return;
		__width = $w;
		__height = $h;
		sizeIsInvalid = true;
		invalidate(InvalidationType.SIZE);
	}
	

    public function ButtonX() 
    {
        super();
    }

	
    public function invalidate():Void
	{
		var i:Number = arguments.length;
		
		if (i)
		{
			while(i --)
			{
				_invalidHash[arguments[i]] = true;
			}
		}
		else
		{
			_invalidHash[InvalidationType.ALL] = true;
		}
		
		if (!_invalid)
		{
			_invalid = true;
			super.invalidate();
		}
	}

	
    private function isInvalid():Boolean
	{
		if (!_invalid)	return false;
		
		var i:Number = arguments.length;
		
		if (i)
		{
			if (_invalidHash[InvalidationType.ALL])	return true;
		
			while(i --)
			{
				if (_invalidHash[arguments[i]])	return true;
			}
			
			return false;
		}
		else
		{
			return	_invalid;
		}
	}

	
    public function validateNow():Void
	{
		if (!_invalid)	return;
		
		super.validateNow();
		
		_invalidHash = { };
		_invalid = false;
	}
	
	
	private function updateText():Void
	{
		if (_label && textField)
		{
			textField.text = _label;
		}
	}

	
    public function draw():Void
	{
		if (sizeIsInvalid)
		{
			alignForAutoSize();
			_width = __width;
			_height = __height;
		}
        
        if (initialized) {        
		    constraints.update(__width, __height);
        } 
		
		super.draw();
		
		
		
	}
}
