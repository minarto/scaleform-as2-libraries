import com.minarto.data.*;

class com.minarto.data.DBind extends Bind
{
	static private function getOffsetTime():Number
	{
		var bind:Bind = BindDic.get("main"), offsetTime:Number, date:Date;
		
		var onTime = function($year:Number, $month:Number, $date:Number, $hour:Number, $min:Number, $sec:Number, $millisec:Number)
		{
			var date:Date = new Date($year, $month, $date, $hour, $min, $sec || 0, $millisec || 0);

			offsetTime = date.getTime() - getTimer();
		}
		
		bind.add("serverDate", null, onTime);
		
		date = new Date;
		bind.evt("serverDate", date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds());
				
		getOffsetTime = function()
		{
			return	offsetTime;
		}
		
		return	getOffsetTime();
	}	

	/**
	 * get current date
	 * @return
	 */
	static public function getDate():Date
	{
		return	new Date(getOffsetTime() + getTimer());
	}	
	
	public function toString():String
	{
		return	"[com.minarto.data.DBind interval:" + getInterval() + "sec]"
	}
	
	
	private var interval:Number = 100, intervalID:Number;	
	
	/**
	 * set interval
	 * @param	$interval
	 */
	public function init($interval:Number):Void
	{
		interval = ($interval || 0.1) * 1000;
		
		if(intervalID)
		{
			this.play();
		}
	}	
	
	private function intervalFunc():Void
	{
		var key:String, date:Date = getDate();
		
		for (key in handlerDic)
		{
			evt(key, date);
		}
	}
	
	
	/**
	 * play
	 */		
	public function play():Void
	{
		clearInterval(intervalID);
		intervalID = setInterval(this, "intervalFunc", interval);
	}	
	
	/**
	 * stop
	 */		
	public function stop():Void
	{
		clearInterval(intervalID);
		intervalID = NaN;
	}	
	
	/**
	 * is playing
	 */		
	public function getIsPlaying():Boolean
	{
		return	Boolean(intervalID);
	}	

	/**
	 * get interval
	 */
	public function getInterval():Number
	{
		return	interval * 0.001;
	}
}
