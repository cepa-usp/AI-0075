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