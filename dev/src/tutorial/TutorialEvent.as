package tutorial 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class TutorialEvent extends Event 
	{
		private var _numBalao:int;
		
		public function TutorialEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TutorialEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TutorialEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get numBalao():int 
		{
			return _numBalao;
		}
		
		public function set numBalao(value:int):void 
		{
			_numBalao = value;
		}
		
	}
	
}