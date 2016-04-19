import com.minarto.filters.*;


class com.minarto.filters.DynamicMatrix
{
	static public var MATRIX_ORDER_PREPEND:Number = 0;
	static public var MATRIX_ORDER_APPEND:Number = 1;

	private var m_width:Number = 0;
	private var m_height:Number = 0;
	private var m_matrix:Array;
	
	
	public function DynamicMatrix(width:Number, height:Number)
	{
		Create(width, height);
	}


	private function Create(width:Number, height:Number):Void
	{
		width = width || 0;
		height = height || 0;
		
		if(width > 0 && height > 0) 
		{
			m_width = width;
			m_height = height;
			
			//m_matrix = new Array(height);
			m_matrix = [];
			m_matrix.length = height;
			for(var i:Number = 0; i < height; i++)
			{
				//m_matrix[i] = new Array(width);
				m_matrix[i] = [];
				m_matrix[i].length = width;
				for(var j:Number = 0; j < height; j++)
				{
					m_matrix[i][j] = 0;
				}
			}
		}
	}
	
	
	private function Destroy():Void
	{
		m_matrix = null;
	}
	
	
	public function GetWidth():Number 
	{
		return m_width;
	}
	
	
	public function GetHeight():Number
	{
		return m_height;
	}
	
	
	public function GetValue(row:Number, col:Number):Number
	{
		var value:Number = 0;
		
		row = row || 0;
		col = col || 0;
		if(row >= 0 && row < m_height && col >= 0 && col <= m_width)
		{
			value = m_matrix[row][col];
		}
		
		return value;
	}


	public function SetValue(row:Number, col:Number, value:Number):Void
	{
		row = row || 0;
		col = col || 0;
		value = value || 0;
		
		if(row >= 0 && row < m_height && col >= 0 && col <= m_width)
		{
			m_matrix[row][col] = value;
		}
	}


	public function LoadIdentity():Void
	{
		if(m_matrix) 
		{
			for(var i:Number = 0; i < m_height; i++)
			{
				for(var j:Number = 0; j < m_width; j++)
				{
					if (i == j)
					{
						m_matrix[i][j] = 1;
					}
					else {
						m_matrix[i][j] = 0;
					}
				}
			}
		}
	}


	public function LoadZeros():Void
	{
		if(m_matrix)
		{
			for(var i:Number = 0; i < m_height; i++)
			{
				for(var j:Number = 0; j < m_width; j++)
				{
					m_matrix[i][j] = 0;
				}
			}
		}
	}


	public function Multiply(inMatrix:DynamicMatrix, order:Number):Boolean
	{
		order = order || MATRIX_ORDER_PREPEND;
		if (!m_matrix || !inMatrix)
		{
			return false;
		}
			
		var inHeight:Number = inMatrix.GetHeight();
		var inWidth:Number = inMatrix.GetWidth();
		
		if(order == MATRIX_ORDER_APPEND)
		{
			//inMatrix on the left
			if (m_width != inHeight)
			{
				return false;
			}
				
			var result:DynamicMatrix = new DynamicMatrix(inWidth, m_height);
			for(var i:Number = 0; i < m_height; i++)
			{
				for(var j:Number = 0; j < inWidth; j++)
				{
					var total:Number = 0;
					for(var k:Number = 0, m:Number = 0; k < Math.max(m_height, inHeight) && m < Math.max(m_width, inWidth); k++, m++)
					{
						total = total + (inMatrix.GetValue(k, j) * m_matrix[i][m]);
					}
					
					result.SetValue(i, j, total);
				}
			}

			// destroy self and recreate with a new dimension
			Destroy();
			Create(inWidth, m_height);
			
			// assign result back to self
			for(i = 0; i < inHeight; i++)
			{
				for(j = 0; j < m_width; j++) 
				{
					m_matrix[i][j] = result.GetValue(i, j);
				}
			}
		}
		
		else
		{
			// inMatrix on the right
			if (m_height != inWidth)
			{
				return false;
			}
				
			result = new DynamicMatrix(m_width, inHeight);
			for(i = 0; i < inHeight; i++)
			{
				for(j = 0; j < m_width; j++)
				{
					total = 0;
					for(k = 0, m = 0; k < Math.max(inHeight, m_height) && m < Math.max(inWidth, m_width); k++, m++)
					{
						total = total + (m_matrix[k][j] * inMatrix.GetValue(i, m));
					}
					result.SetValue(i, j, total);
				}
			}
			
			// destroy self and recreate with a new dimension
			Destroy();
			Create(m_width, inHeight);
			
			// assign result back to self
			for(i = 0; i < inHeight; i++)
			{
				for(j = 0; j < m_width; j++)
				{
					m_matrix[i][j] = result.GetValue(i, j);
				}
			}
		}
		
		return true;
	}
	
	
	
	public function MultiplyNumber(value:Number):Boolean
	{
		if (!m_matrix)
		{
			return false;
		}
		
		for(var i:Number = 0; i < m_height; i++)
		{
			for(var j:Number = 0; j < m_width; j++)
			{
				var total:Number = 0;
				total = m_matrix[i][j] * value;
				m_matrix[i][j] = total;
			}
		}
		
		return true;
	}


	public function Add(inMatrix:DynamicMatrix):Boolean
	{
		if (!m_matrix || !inMatrix)
		{
			return false;
		}
		
		var inHeight:Number = inMatrix.GetHeight();
		var inWidth:Number = inMatrix.GetWidth();
		
		if (m_width != inWidth || m_height != inHeight)
		{
			return false;
		}
			
		for(var i:Number = 0; i < m_height; i++)
		{
			for(var j:Number = 0; j < m_width; j++)
			{
				var total:Number = 0;
				total = m_matrix[i][j] + inMatrix.GetValue(i, j);
				m_matrix[i][j] = total;
			}
		}
		
		return true;
	}
}
