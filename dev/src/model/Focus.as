package model 
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Focus implements ChallengeElement
	{
		
		private var _distance:Number = 0;
		public function Focus() 
		{
			
		}
		
		/* INTERFACE model.ChallengeElement */
		
		public function get inverted():Boolean 
		{
				return false;
		}
		
		public function set inverted(value:Boolean):void 
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
		
	}
	
}