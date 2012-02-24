package model 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class ChallengeEvent extends Event 
	{
		private var _challenge:Challenge;
		
		public function ChallengeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ChallengeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ChallengeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public static const STATE_CHANGE:String = "StateChange";
		
		public function get challenge():Challenge 
		{
			return _challenge;
		}
		
		public function set challenge(value:Challenge):void 
		{
			_challenge = value;
		}
		
	}
	
}