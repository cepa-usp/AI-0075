package view 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class DragHandler extends Sprite
	{
		public function DragHandler() 
		{
		
		}
		
		public function setIcon(d:DisplayObject):void {
			addChild(d);
		}
		
		public function init():void {
			stage.addEventListener(MouseEvent.MOUSE_UP, release)
			stage.addEventListener(Event.ENTER_FRAME, onMove)
			this.startDrag(true);
		}
		
		public function onMove(e:Event) {
			dispatchEvent(new Event("PositionChanged", true));
		}
		
		
		private function release(e:MouseEvent):void 
		{
			this.stopDrag();
			stage.removeEventListener(Event.ENTER_FRAME, onMove)
			stage.removeEventListener(MouseEvent.MOUSE_UP, release)
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function dispose():void {
			this.parent.removeChild(this);
		}
		

		
	}
	
}