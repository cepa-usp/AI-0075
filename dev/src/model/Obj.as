package model 
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Obj  implements ChallengeElement
	{
		private var _distance:Number = 0;
		private var _inverted:Boolean = false;
		private var _size:Number = 0;
		private var _image:Boolean = false;
		public function Obj() 
		{
			
		}
		
		public function get distance():Number 
		{
			return _distance;
		}
		
		public function set distance(value:Number):void 
		{
			_distance = value;
		}
		
		public function get size():Number 
		{
			return _size;
		}
		
		public function set size(value:Number):void 
		{
			_size = value;
		}
		
		public function get inverted():Boolean 
		{
			return _inverted;
		}
		
		public function set inverted(value:Boolean):void 
		{
			_inverted = value;
		}
		
		public function get image():Boolean 
		{
			return _image;
		}
		
		public function set image(value:Boolean):void 
		{
			_image = value;
		}
		
	}
	
}