package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.Challenge;
	import model.ChallengeEvent;
	import model.Mirror;
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
			
			var bt2:Sprite = new Sprite();
			bt2.graphics.beginFill(0x008000);
			bt2.graphics.drawRect(0, 0, 50, 20);
			bt2.x = 10;
			bt2.y = 50;						
			bt2.addEventListener(MouseEvent.MOUSE_DOWN, createLine)
			sprButtons.addChild(bt2);		
			
			
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
			var challenge:Challenge = new Challenge();
			challenge.eventDispatcher.addEventListener(ChallengeEvent.STATE_CHANGE, onChallengeStateChange);
			challenge.createChallenge();
			scene.draw(challenge);			
		}
		
		private function onChallengeStateChange(e:ChallengeEvent):void 
		{
			var c:Challenge = e.challenge;
			switch (c.state) {
				case Challenge.CHALLENGESTATUS_CREATING:
					hideTools()
					break;
				case Challenge.CHALLENGESTATUS_WAITINGANSWER:
					showTools();
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
			
		}
		
		private function showTools():void 
		{
			
		}
		
		private function showAnswerTools():void 
		{
			
		}
		
		private function computeScore():void 
		{
			
		}
		
		
		
		private function changeChallengeState() {
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(sprScene);
			addChild(sprButtons);
			drawButtons();
			changeState(1);
		}
		
		
		public static const STATE_TUTORIAL:int = 0;
		public static const STATE_CHALLENGE:int = 1;
		
		
	}
	
}