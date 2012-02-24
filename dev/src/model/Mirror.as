package model 
{
	import flash.events.FocusEvent;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Mirror
	{
		private var _type:int = 0;
		private var _position:Number = 0;
		private var _focus:Focus = new Focus();

		public static const CONCAVE:int = 0;
		public static const CONVEX:int = 1;
		
		
		public function Mirror() 
		{
			
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
		public function get position():Number 
		{
			return _position;
		}
		
		public function set position(value:Number):void 
		{
			_position = value;
		}
		
		public function get focus():Focus 
		{
			return _focus;
		}
		
		public function set focus(value:Focus):void 
		{
			_focus = value;
		}

		
		
	}
	
}