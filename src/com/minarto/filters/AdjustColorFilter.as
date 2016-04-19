import com.minarto.filters.*;

import flash.filters.ColorMatrixFilter;


class com.minarto.filters.AdjustColorFilter extends ColorMatrixFilter
{
	private var adjustColor:AdjustColor, _brightness:Number = 0, _contrast:Number = 0, _saturation:Number = 0, _hue:Number = 0;
	
	
	public function AdjustColorFilter($brightness:Number, $contrast:Number, $saturation:Number, $hue:Number)
	{
		super(convert($brightness, $contrast, $saturation, $hue));
	}
	
	
	private function convert($brightness:Number, $contrast:Number, $saturation:Number, $hue:Number):Array
	{
		adjustColor = new AdjustColor;
		
		setBrightness($brightness);
		setContrast($contrast);
		setSaturation($saturation);
		setHue($hue);
		
		return	adjustColor.CalculateFinalFlatArray();
	}
	
	
	public function setBrightness($v:Number):Void
	{
		_brightness = $v;
		adjustColor.setBrightness($v);
	}
	
	
	public function setContrast($v:Number):Void
	{
		_contrast = $v;
		adjustColor.setContrast($v);
	}
	
	
	public function setSaturation($v:Number):Void
	{
		_saturation = $v;
		adjustColor.setSaturation($v);
	}
	
	
	public function setHue($v:Number):Void
	{
		_hue = $v;
		adjustColor.setHue($v);
	}
}
