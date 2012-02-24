package model 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Challenge 
	{
		private var _mirror:Mirror;
		private var _object:Obj;
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();
		private var _image:Obj;
		private var _state:int = 0;
		private var _hiddenElement:ChallengeElement;
		
		
		public function Challenge() 
		{
			
		}
		
		public function createChallenge(focusDistance:Number=Number.NaN, objectDistance:Number=Number.NaN, objectSize:Number=Number.NaN, mirrorType:int=-1):void {

			mirror = new Mirror();
			if(mirrorType==-1){
				mirror.type = Math.floor(Math.random() * 2);
			} else {
				mirror.type = mirrorType;
			}
			if(isNaN(focusDistance)){
				mirror.focus.distance = Math.floor(Math.random() * (Config.MAX_FOCUS_DISTANCE - Config.MIN_FOCUS_DISTANCE)) + Config.MIN_FOCUS_DISTANCE;			
			} else {
				mirror.focus.distance = Math.abs(focusDistance);
			}
			if (mirror.type == Mirror.CONVEX) mirror.focus.distance *= -1;
			object = new Obj();
			if (isNaN(objectDistance)) {
			var foi:Boolean = true;
				while(foi){
					object.distance = Math.floor(Math.random() * Config.MAX_OBJ_DISTANCE);
					if (object.distance > Math.abs(mirror.focus.distance) / 2) foi = false;
				}				
			} else {
				object.distance = objectDistance;
			}

			object.inverted = false; // (Math.random() > .5 ? true : false);
			if (isNaN(objectSize)) {
				object.size = Math.floor(Math.random() * (Config.MAX_OBJ_SIZE - Config.MIN_OBJ_SIZE)) + Config.MIN_OBJ_SIZE;	
			} else {
				object.size = objectSize;
			}
			
			
			image = new Obj();			
			image.distance = 1 / ((1 / mirror.focus.distance) - (1 / object.distance));
			
			image.size = ((image.distance * -1) * object.size) / object.distance;
			if (image.size < 0) image.inverted = !object.inverted;
			
			if (Math.abs(image.size) < (object.size * 0.1) || image.size > (object.size * 2)) {
				trace(image.size, (object.size * 0.1) , (object.size * 3))
				createChallenge(focusDistance, objectDistance, objectSize, mirrorType);
				//return;
			}
			
			var rnd:int = Math.floor(Math.random() * 3);
			switch(rnd) {
				case 1:
					hiddenElement = object;
					break;
				case 2:
					hiddenElement = image;
					break;
				case 3:
					hiddenElement = mirror.focus;
					break;
			}
		}
		
		public function get mirror():Mirror 
		{
			return _mirror;
		}
		
		public function set mirror(value:Mirror):void 
		{
			_mirror = value;
		}
		
		public function get object():Obj 
		{
			return _object;
		}
		
		public function set object(value:Obj):void 
		{
			_object = value;
		}
		
		public function get image():Obj 
		{
			return _image;
		}
		
		public function set image(value:Obj):void 
		{
			_image = value;
		}
		
		public function get hiddenElement():ChallengeElement 
		{
			return _hiddenElement;
		}
		
		public function set hiddenElement(value:ChallengeElement):void 
		{
			_hiddenElement = value;
		}
		
		public function get eventDispatcher():EventDispatcher 
		{
			return _eventDispatcher;
		}
		
		public function set eventDispatcher(value:EventDispatcher):void 
		{
			_eventDispatcher = value;
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function set state(value:int):void 
		{
			_state = value;
		}
		
		public function toString():String {
			var str:String = "mirror: " + (mirror.type == Mirror.CONCAVE? "concave": "convex") + "\n";
			str += "focus distance : " + mirror.focus.distance.toString() + "\n";
			str += "object distance: " + object.distance.toString() + "; size: " + object.size.toString() + "\n"
			str += "image distance: " + image.distance.toString() + "; size: " + image.size.toString() + "\n"
			str += (image.distance > 0? "real\n": "virtual\n");
			str += (image.size > 0? "straight": "inverted");
			str += "\n************************************** \n"
			return str;
		}
		
		
		public static const CHALLENGESTATUS_CREATING = 1;
		public static const CHALLENGESTATUS_WAITINGANSWER = 2;
		public static const CHALLENGESTATUS_EVALUATING = 3;
		public static const CHALLENGESTATUS_SHOWANSWER = 4;		
		
		
		
	}
	
}