package model 
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public interface ChallengeElement 
	{
		function get distance():Number;
		function set distance(value:Number):void;
		function get inverted():Boolean;
		function set inverted(value:Boolean):void;
		function get size():Number;
		function set size(value:Number):void;
		function clone():ChallengeElement;
	}
	
}