class com.minarto.data.DBindDic
{
	static public function get($interval:Number):DBind
	{
		var dic = {};
		
		DBindDic.get = function($interval:Number)
		{
			var db:DBind = dic[$interval];
			
			if(!db)
			{
				dic[$interval || 0.1] = db = new DBind;
				db.init($interval);
			}
			return	db;
		}
		
		return	DBindDic.get($interval);
	}
}
