class com.minarto.data.BindDic
{
	static private var dic = { };
	

	static public function link($uid0, $uid1):Void
	{
		var b:Bind = dic[$uid0] || get($uid1);
		
		dic[$uid0] = b;
		dic[$uid1] = b;
	}
	
	
	static public function get($uid):Bind
	{
		return	dic[$uid] || (dic[$uid] = new Bind);
	}
	
		
	static public function set($uid, $key, $value):Void
	{
		var b:Bind = get($uid);
		
		b.set.apply(b, arguments.slice(1));
	}
	

	static public function evt($uid, $key, $value):Void
	{
		var b:Bind = get($uid);
		
		b.evt.apply(b, arguments.slice(1));
	}
}
