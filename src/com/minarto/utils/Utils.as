import com.minarto.utils.*;


class com.minarto.utils.Utils
{
	public function Utils()
	{
	}
	
	
	public function checkStrByte($msg:String):Number
	{
		var i:Number = ($msg || "").length, totalByte:Number = 0;
		
		while (i--)
		{
			if (escape($msg.charAt(i)).length > 4)
			{
				totalByte += 2;
			}
			else
			{
				++ totalByte;
			}
		}
		
		return	totalByte;
	}
}
