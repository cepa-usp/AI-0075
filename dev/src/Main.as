package 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import model.Challenge;
	import model.ChallengeEvent;
	import model.Focus;
	import model.Mirror;
	import model.Obj;
	import tutorial.CaixaTexto;
	import tutorial.Tutorial;
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
		private var sprAboutScreen:AboutScreen = new AboutScreen();
		private var sprInfoScreen:InstScreen = new InstScreen();
		private var layerTools:Sprite  = new Sprite();
		private var sprLabel:BottomMessage = new BottomMessage();
		private var sprAnswer:Sprite = new Sprite();
		private var challenge:Challenge;
		private var btGetLine:Sprite;
		private var btNovo:Sprite;
		private var btGetElement:Sprite;
		private var btEvaluate:Sprite;
		private var btShowAnswer1:Sprite;
		private var btShowAnswer2:Sprite;
		private var viewAnswer:Boolean = false;
		private var screenOptions:ScreenOptions;
		private var botoes:Botoes;
		private var scorm:ScormComm = new ScormComm();
		private var screenMessage:String;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		public function drawButtonMenu():void {
			botoes = new Botoes();
			botoes.x = Config.WIDTH - botoes.width - 10;
			botoes.y = Config.HEIGHT - botoes.height - 10;			
			addChild(botoes);
			workAsButton(botoes.btCreditos);
			workAsButton(botoes.btOrientacoes);
			workAsButton(botoes.btReset);
			workAsButton(botoes.btTutorial);			
			botoes.btReset.addEventListener(MouseEvent.CLICK, performReset);
			botoes.btCreditos.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { openPanel(sprAboutScreen) } );
			botoes.btOrientacoes.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { openPanel(sprInfoScreen) });
			botoes.filters = [new DropShadowFilter(4, 45, 0, 1)];

		}
		
		public function drawButtons():void {
			drawButtonMenu();			
			addScreenOptions();
			drawAnswer();
		}
		
		public function drawAnswer():void {
			btShowAnswer1 = new BtRespostaCorreta();
			btShowAnswer2 = new BtSuaResposta();
			btNovo = new BtNovo();
			sprAnswer.addChild(btShowAnswer1);
			sprAnswer.addChild(btShowAnswer2);
			sprAnswer.addChild(btNovo);
			workAsButton(btShowAnswer1);
			workAsButton(btShowAnswer2);
			workAsButton(btNovo);
			btShowAnswer1.x = Config.WIDTH/2;
			btShowAnswer1.y = 100;
			btShowAnswer2.x = Config.WIDTH/2;
			btShowAnswer2.y = 100;		
			btNovo.x = Config.WIDTH/2;
			btNovo.y = 70;					
			btShowAnswer1.addEventListener(MouseEvent.CLICK, showAnswer)
			btShowAnswer2.addEventListener(MouseEvent.CLICK, showAnswer)
			btNovo.addEventListener(MouseEvent.CLICK, performReset)
			btShowAnswer1.visible = true;
			btShowAnswer2.visible = false;
			sprAnswer.visible = false;
			
			
			
			
		}
		

		private function addScreenOptions():void 
		{
			screenOptions = new ScreenOptions();
			screenOptions.filters = [new DropShadowFilter() ];
			addChild(screenOptions);
			screenOptions.x = 10;
			screenOptions.y = 10;
			workAsButton(screenOptions.btEvaluate);
			workAsButton(screenOptions.btLines);
			screenOptions.btLines.addEventListener(MouseEvent.MOUSE_DOWN, createLine);
			screenOptions.btLines.addEventListener(MouseEvent.MOUSE_OVER, infoLine);
			screenOptions.btLines.addEventListener(MouseEvent.MOUSE_OUT, info);
			screenOptions.btEvaluate.addEventListener(MouseEvent.CLICK, evaluate);
		}
		
		private function info(e:MouseEvent):void 
		{
			setMessage(screenMessage)
		}
		
		private function infoLine(e:MouseEvent):void 
		{
			setMessage("Use o lápis e a borracha para traçar linhas guias, para auxiliar na construção geométrica.");
		}
		
		private function workAsButton(o:DisplayObject):void {
			if (o is MovieClip) {				
				MovieClip(o).useHandCursor = true;
				MovieClip(o).buttonMode = true;
				MovieClip(o).mouseChildren = false;
				MovieClip(o).addEventListener(MouseEvent.MOUSE_OVER, buttonOnMouseOver);
				MovieClip(o).addEventListener(MouseEvent.MOUSE_OUT, buttonOnMouseOut);
				MovieClip(o).gotoAndStop(1);
			}
		}
		
		private function buttonOnMouseOut(e:MouseEvent):void 
		{
			MovieClip(e.target).gotoAndStop(1);
		}
		
		private function buttonOnMouseOver(e:MouseEvent):void 
		{
			MovieClip(e.target).gotoAndStop(5);
		}
		
		private function showAnswer(e:MouseEvent):void 
		{
			if (viewAnswer == false) {
				viewAnswer = true;				
			} else {
				viewAnswer = false;
			}
			scene.showAnswer(viewAnswer);
			btShowAnswer2.visible = viewAnswer;
			btShowAnswer1.visible = !viewAnswer;
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

		
		private function getIncogName():String {
			if (challenge.hiddenElement is Obj) {
				if (Obj(challenge.hiddenElement).image == true) {
					return "a imagem"
				} else {
					return "o objeto"
				}
			} else if (challenge.hiddenElement is Focus) {
				return "o foco"
			}
			return "";
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
					setMessage("Criando nova situação");
					hideTools()
					hideAnswerTools();
					break;
				case Challenge.CHALLENGESTATUS_WAITINGPOSITION:
				
					setMessage("Arraste o elemento no canto superior esquerdo da tela (" + getIncogName() + ") e posicione-o de modo a completar a construção geométrica.", true);
						//setMessage("Pegue o elemento da caixa (" + getIncogName() + ") e arraste-o para dentro do cenário.");
					showTools();
					break;
				case Challenge.CHALLENGESTATUS_WAITINGANSWER:
					setMessage("Posicione o elemento e, quando tiver concluído, pressione 'terminei'. Se precisar inverter o elemento, pegue-o pelo topo e arraste para baixo.", true);
					btGetElement.removeEventListener(MouseEvent.MOUSE_DOWN, createElement)
					break;					
				case Challenge.CHALLENGESTATUS_EVALUATING:
					setMessage("Avaliando...", true);
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
		Actuate.tween(screenOptions, 1, { alpha:0 }, true);
			//btShowAnswer.visible = false;
		}
		
		private function showTools():void 
		{
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
			btGetElement.addEventListener(MouseEvent.MOUSE_OVER, infoElement)
			btGetElement.addEventListener(MouseEvent.MOUSE_OUT, info)
			screenOptions.addChild(btGetElement);			
			btGetElement.x = screenOptions.box.x;// + screenOptions.box.width / 2;
			btGetElement.y = screenOptions.box.y;// + screenOptions.box.height  / 2;
			Actuate.tween(screenOptions, 1, { alpha:1 }, true);			
		}
		
		private function infoElement(e:MouseEvent):void 
		{
			setMessage("Este é o elemento que falta na construção geométrica. Arraste-o e posicione-o corretamente.")
		}
		
	
		
		
		private function createElement(e:MouseEvent):void 
		{
			var dh:DragHandler = new DragHandler();
			dh.addEventListener(Event.COMPLETE, onFinishElementDrag)
			scene.addGhostElement(dh);
			if (challenge.hiddenElement is Focus) dh.setIcon(new SpriteDot());
			if (challenge.hiddenElement is Obj) {
				if (Obj(challenge.hiddenElement).image) {
					dh.setIcon(new Seta());
				} else {
					dh.setIcon(new Seta());
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
		
		private function hideAnswerTools():void 
		{
			sprAnswer.alpha = 0;
			sprAnswer.visible = false;

		}		
		

		private function showAnswerTools():void 
		{
			viewAnswer = false;
			btShowAnswer1.visible = true;
			btShowAnswer2.visible = false;
			sprAnswer.visible = true;
			sprAnswer.alpha = 0;
			Actuate.tween(sprAnswer, 1, { alpha:1 } );
		}
		
		private function computeScore():void 
		{
			
			setMessage("Resultado: " + challenge.score.toString() + "/100. Pressione 'novo exercício' para começar um outro exercício, diferente do anterior.", true);
			
			//btShowAnswer1.visible = true;
			//btShowAnswer2.visible = false;
			
		}
		
		

		private function startTutorial():void {
			reset()
			var challenge:Challenge = new Challenge();
			challenge.createChallenge(87, 253, 41, Mirror.CONVEX);
			scene.draw(challenge);
			
			var tut:Tutorial = new Tutorial();

			tut.adicionarBalao("teste1", new Point(30, 30), CaixaTexto.LEFT, CaixaTexto.FIRST);
			tut.adicionarBalao("teste2", new Point(66, 130), CaixaTexto.RIGHT, CaixaTexto.CENTER);
			tut.adicionarBalao("teste1", new Point(30, 30), CaixaTexto.LEFT, CaixaTexto.FIRST);
			tut.iniciar(stage);
			
		}
		
		
		
		
		
		private function init(e:Event = null):void 
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			scorm.initLMSConnection(0, 100);

			//addChild(new Background());
			addChild(sprButtons);
			addChild(layerTools);
			addChild(sprScene);
			addChild(sprLabel);
			addChild(sprAnswer);
			
			sprAboutScreen.x = Config.WIDTH / 2
			sprAboutScreen.y = Config.HEIGHT / 2
			sprAboutScreen.addEventListener(MouseEvent.CLICK, closePanel);
			
			sprInfoScreen.x = Config.WIDTH / 2
			sprInfoScreen.y = Config.HEIGHT / 2
			sprInfoScreen.addEventListener(MouseEvent.CLICK, closePanel);
			
			
			drawButtons();
			drawLabel();
			addChild(sprAboutScreen);
			addChild(sprInfoScreen);
			sprAboutScreen.visible = false;
			sprInfoScreen.visible = false;
			addChild(new LOBorder());
			

			changeState(1);
			startTutorial();
		}
		
		private function closePanel(e:MouseEvent):void 
		{
			e.target.gotoAndPlay(2);
			Actuate.tween(e.target, 0.5, { alpha:0.8 } ).onComplete(setPanelInvisbile, e.target);
		}
		
		private function setPanelInvisbile(d:DisplayObject):void 
		{
			d.visible = false;
		}
		
		private function openPanel(d:MovieClip):void {
			d.visible = true;
			d.alpha = 0;
			d.gotoAndStop(1);						
			Actuate.tween(d, 0.5, { alpha:1 } );
		}
		
		private function closePanel(e:MouseEvent):void 
		{
			e.target.gotoAndPlay(2);
			Actuate.tween(e.target, 0.5, { alpha:0.8 } ).onComplete(setPanelInvisbile, e.target);
		}
		
		private function setPanelInvisbile(d:DisplayObject):void 
		{
			d.visible = false;
		}
		
		private function openPanel(d:MovieClip):void {
			d.visible = true;
			d.alpha = 0;
			d.gotoAndStop(1);						
			Actuate.tween(d, 0.5, { alpha:1 } );
		}
		
		private function drawLabel():void 
		{
			sprLabel.x = 0;
			sprLabel.y = Config.HEIGHT - sprLabel.height;
		}
		
		private function setMessage(tx:String, save:Boolean = false):void {
			if (save) screenMessage = tx;
			sprLabel.legenda.texto.text = tx;
			
		}
		
		
		public static const STATE_TUTORIAL:int = 0;
		public static const STATE_CHALLENGE:int = 1;
		

	}
	
	
}