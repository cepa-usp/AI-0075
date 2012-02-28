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
		private var _element:ChallengeElement;
		private var _score:Number = 0;
		
		
		public function Challenge() 
		{
			
		}
		
		public function createChallenge(focusDistance:Number=Number.NaN, objectDistance:Number=Number.NaN, objectSize:Number=Number.NaN, mirrorType:int=-1):void {
			this.state = CHALLENGESTATUS_CREATING;
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
			image.image = true;
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
				case 0:
					hiddenElement = object.clone();
					element = object;
					break;
				case 1:
					hiddenElement = image.clone();
					element = image;
					break;
				case 2:
					hiddenElement = mirror.focus.clone();
					element = mirror.focus;
					break;
			}
			this.state = CHALLENGESTATUS_WAITINGPOSITION;
		}
		
		public function evaluate():void {
			state = CHALLENGESTATUS_EVALUATING;
			var distancia:Number = 0;
			var sentido:Number = 100;
			var tamanho:Number = 100;
						
			if (hiddenElement.distance <  element.distance + 2*(element.distance/10) && hiddenElement.distance > element.distance - 2*(element.distance/10)) distancia = 80;
			if (hiddenElement.distance <  element.distance + element.distance/10 && hiddenElement.distance > element.distance - element.distance/10) distancia = 100;
			
			
			
			if (element is Obj) {
				if (Obj(element).image == true) {
					tamanho = 0;
					if (hiddenElement.size <  element.size + 2*(element.size/10) && hiddenElement.size> element.size - 2*(element.size/10)) tamanho = 80;
					if (hiddenElement.size <  element.size + element.size/10 && hiddenElement.size > element.size - element.size/10) tamanho = 100;
					
				
					sentido = 0;
					if (hiddenElement.inverted == element.inverted) sentido = 100;					
				}
			}
			
			score = Math.min(distancia, tamanho, sentido);
			trace(distancia, tamanho, sentido, score);
			
			
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
			eventDispatcher.dispatchEvent(new ChallengeEvent(ChallengeEvent.STATE_CHANGE, true));
		}
		
		public function get element():ChallengeElement 
		{
			return _element;
		}
		
		public function set element(value:ChallengeElement):void 
		{
			_element = value;
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
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
		
		
		public static const CHALLENGESTATUS_CREATING:int = 1;
		public static const CHALLENGESTATUS_WAITINGPOSITION:int = 2;
		public static const CHALLENGESTATUS_WAITINGANSWER:int = 3;
		public static const CHALLENGESTATUS_EVALUATING:int = 4;
		public static const CHALLENGESTATUS_SHOWANSWER:int = 5;		
		
		
		
	}
	
}