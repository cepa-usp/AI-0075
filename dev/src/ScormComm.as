package 
{
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		//import pipwerks.SCORM;
		import flash.events.EventDispatcher;
		import flash.events.Event;
		import flash.display.Sprite;

	public class  ScormComm extends Sprite
	{
		public var completed:Boolean;
		public var learner_name:String;
		
		private var scorm:SCORM;
		public var scormExercise:int;		
		public var connected:Boolean;
		public var score:int;
		public var completion_status:String = ""
		private var pingTimer:Timer;
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos		
	
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		public function initLMSConnection (scoreMin:int, scoreMax:int) : void
		{
			completed = false;
			connected = false;
			pingTimer = new Timer(PING_INTERVAL)
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS)
			scorm = new SCORM();
			scorm.debugMode = false;
			
			
			connected = scorm.connect();
			
			if (connected) {
 				
				// Verifica se a AI já foi concluída.
				var stats:String = scorm.get("cmi.completion_status");				
				completion_status = stats;
			 	learner_name = scorm.get("cmi.learner_name");
				
				switch(stats) {
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						scormExercise = 1;
						score = 0;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						scormExercise = parseInt(scorm.get("cmi.location"))+1;
						score = parseInt(scorm.get("cmi.score.raw"));
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						scormExercise = parseInt(scorm.get("cmi.location"))+1;
						score = parseInt(scorm.get("cmi.score.raw"));
						setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				var success:Boolean = scorm.set("cmi.score.min", scoreMin.toString());
				if (success) success = scorm.set("cmi.score.max", scoreMax.toString());
				
				if (success){
					scorm.save();
					pingTimer.start();
				} else	{
					setMessage("Falha ao enviar dados ao LMS");
					connected = false;
				} 
			} else	{
				setMessage("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
			}			


			//reset();
		}
		
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		public function save2LMS ():void
		{
			if (connected)	{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());

				if (success){
					scorm.save();
				}
				else {
					pingTimer.stop();
					setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent):void
		{
			scorm.get("cmi.completion_status");
			return;

			// daqui pra baixo não opera mais 
			if (connected)
			{
				var success:Boolean = scorm.set("cmi.session_time", Math.round(pingTimer.currentCount * PING_INTERVAL / 1000).toString());
				
				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}
			
		}
		
		private var lastMessage:String = ""

		public function getLastMessage():String {
			return lastMessage;
		}
		
		private function setMessage (msg:String = null) : void
		{
			lastMessage = msg;
			
			dispatchEvent(new Event("ENVIOU_MENSAGEM", true));

			
		}
	}
	
}