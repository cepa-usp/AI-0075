package 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.Challenge;
	import model.ChallengeEvent;
	import model.Focus;
	import model.Mirror;
	import model.Obj;
	import view.DragHandler;
	import view.Line;
	import view.Scene;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite 
	{
		private var state:int = STATE_TUTORIAL;
		private var score:int = 0;
		private var scene:Scene = null;
		private var sprScene:Sprite = new Sprite();
		private var sprButtons:Sprite = new Sprite();
		private var layerTools:Sprite  = new Sprite();
		private var challenge:Challenge;
		private var btGetLine:Sprite;
		private var btGetElement:Sprite;
		private var btEvaluate:Sprite;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		public function drawButtons():void {
			var bt:Sprite = new Sprite();
			bt.graphics.beginFill(0x008000);
			bt.graphics.drawRect(0, 0, 50, 20);
			bt.x = 10;
			bt.y = 20;			
			bt.addEventListener(MouseEvent.CLICK, performReset)
			sprButtons.addChild(bt);
			
			btEvaluate = new Sprite();
			btEvaluate.graphics.beginFill(0x008000);
			btEvaluate.graphics.drawRect(0, 0, 50, 20);
			btEvaluate.x = 60;
			btEvaluate.y = 20;			
			btEvaluate.addEventListener(MouseEvent.CLICK, evaluate)
			sprButtons.addChild(btEvaluate);
		}
		
		private function evaluate(e:MouseEvent):void 
		{
			challenge.evaluate();
		}
		
		
		

		
		

		private function createLine(e:MouseEvent):void 
		{
			var dh:DragHandler = new DragHandler();
			dh.addEventListener(Event.COMPLETE, onFinishLineDrag)
			addChild(dh);
			dh.setIcon(new SpriteDot());
			dh.init();
			
		}
		
		private function onFinishLineDrag(e:Event):void 
		{
			scene.addLine(mouseX, mouseY);
			removeChild(DragHandler(e.target));
		}

		
		private function performReset(e:MouseEvent):void 
		{
			changeState(state);
		}
		
		public function reset():void 
		{
			if(scene!=null){
				try {
					sprScene.removeChildAt(0);	
				} catch (e:Error) {
					
				}
			}
			scene = new Scene();			
			sprScene.addChild(scene);
		}
		
		public function changeState(vstate:int):void {
			
			switch(vstate) {
				case 0:
					state = vstate;
					startTutorial();
					break;
				case 1:					
					state = vstate;
					startChallenge();
					break;
			}
		}
		
		
		private function startTutorial():void {
			reset()
			var challenge:Challenge = new Challenge();
			challenge.createChallenge(87, 253, 41, Mirror.CONVEX);
			scene.draw(challenge);
		}
		
		private function startChallenge():void {
			reset();
			challenge = new Challenge();
			challenge.eventDispatcher.addEventListener(ChallengeEvent.STATE_CHANGE, onChallengeStateChange);
			challenge.createChallenge();
			scene.draw(challenge);			
		}
		
		private function onChallengeStateChange(e:ChallengeEvent):void 
		{
			switch (challenge.state) {
				case Challenge.CHALLENGESTATUS_CREATING:
					hideTools()
					break;
				case Challenge.CHALLENGESTATUS_WAITINGPOSITION:
					showTools();
					break;
				case Challenge.CHALLENGESTATUS_WAITINGANSWER:
					btGetElement.removeEventListener(MouseEvent.MOUSE_DOWN, createElement)
					break;					
				case Challenge.CHALLENGESTATUS_EVALUATING:
					hideTools()
					break;
				case Challenge.CHALLENGESTATUS_SHOWANSWER:
					computeScore();
					showAnswerTools();
					break;					
			}
			
		}
		
		private function hideTools():void 
		{
			Actuate.tween(layerTools, 1, { alpha:0 }, true);
		}
		
		private function showTools():void 
		{
			drawTools();
			Actuate.tween(layerTools, 1, { alpha:1 }, true);			
		}
		
		public function drawTools():void {
			//layerTools = new Sprite();
			
			btGetLine = new Sprite();
			btGetLine.graphics.beginFill(0x008000);
			btGetLine.graphics.drawRect(0, 0, 50, 20);
			btGetLine.x = 10;
			btGetLine.y = 50;						
			btGetLine.addEventListener(MouseEvent.MOUSE_DOWN, createLine)
			layerTools.addChild(btGetLine);
			
			
			if (challenge.hiddenElement is Focus) btGetElement = new DragFocus();
			if (challenge.hiddenElement is Obj) {
				if (Obj(challenge.hiddenElement).image) {
					btGetElement = new DragImage();
				} else {
					btGetElement = new DragObject();
				}
			}
			btGetElement.x = 30;
			btGetElement.y = 100;
			btGetElement.addEventListener(MouseEvent.MOUSE_DOWN, createElement)
			layerTools.addChild(btGetElement);
			
		}
		

		
		
		private function createElement(e:MouseEvent):void 
		{
			var dh:DragHandler = new DragHandler();
			dh.addEventListener(Event.COMPLETE, onFinishElementDrag)
			scene.addGhostElement(dh);
			if (challenge.hiddenElement is Focus) dh.setIcon(new SpriteDot());
			if (challenge.hiddenElement is Obj) {
				if (Obj(challenge.hiddenElement).image) {
					dh.setIcon(new SpriteArrowImage());
				} else {
					dh.setIcon(new SpriteArrow());
				}
			}

			dh.init();			
		}
		
		private function onFinishElementDrag(e:Event):void 
		{
			var posx:int = DragHandler(e.target).x;
			challenge.hiddenElement.distance 
			scene.receiveElement(DragHandler(e.target))
			
			
		}
				
		private function showAnswerTools():void 
		{
			
		}
		
		private function computeScore():void 
		{
			
		}
		
		
		
		private function changeChallengeState():void {
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(sprButtons);
			addChild(layerTools);
			addChild(sprScene);
			drawButtons();
			changeState(1);
		}
		
		
		public static const STATE_TUTORIAL:int = 0;
		public static const STATE_CHALLENGE:int = 1;
		
		
	}
	
}