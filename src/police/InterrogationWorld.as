package police
{
	import cutscenes.TrialCutscene;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import trial.JuryEntity;
	import trial.TrialWorld;
	
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class InterrogationWorld extends BaseWorld 
	{
		[Embed(source = '../../img/police/line.png')] public static const LINE_SPRITE:Class;
		[Embed(source = '../../img/police/action_pic.png')] public static const ACTION_SPRITE:Class;
		[Embed(source = '../../img/police/gamebg.png')] public static const BACKDROP1:Class;
		
		/**
		 * Time, in seconds, between each spawn.
		 */
		private var _spawnInterval:Number = 2;
		
		public function set SpawnInterval(value:Number):void { _spawnInterval = Math.max(0.5, value); }
		
		public function get SpawnInterval():Number { return _spawnInterval; }
		
		/**
		 * Chance of a powerup (either good or bad) showing up instead of an allegation.
		 */
		public var PowerupChance:Number = 0.2;
		
		/**
		 * The guilty block that denotes progress from guilty to free.
		 */
		public var ProgressBar:ProgressBarEntity;
		
		/**
		 * The red-green line that the bar follows.
		 */
		public var ProgressLine:BaseEntity;
		
		/**
		 * Tween used to set next spawn.
		 */
		public var SpawnTimer:Alarm;
		
		/**
		 * The player, duh!
		 */
		public var Player:InterrogationCharacter;
		
		public var Scenery:BaseEntity;
		
		public function InterrogationWorld() 
		{
			super();
			
			_createBg();
			_createLine();
			_createBar();
			_createTimer();
			_createPlayer();
			_createAction();
			
			_setLayers();
			
			Powerup.OnPickedUp = OnPowerup;
			_createHelpText();
			
			Pause();
		}
		
		private function _createBg():void
		{
			Scenery = new BaseEntity(0, FP.halfHeight + 30, new Backdrop(BACKDROP1, true, false));
			add(Scenery);
		}
		
		private function _createHelpText():void
		{
			HelpEntity = new FlashTextEntity("Avoid the allegations and\nfake settlements to\nremove evidence!");
		}
		
		private function _setLayers():void
		{

		}
		
		private function _createAction():void
		{
			var e:BaseEntity = new BaseEntity(0, 0, new Image(ACTION_SPRITE));
			(e.graphic as Image).scale = Main.GAME_SCALE;
			add(e);
			
			e.graphic.scrollX = 0;
		}
		
		private function _createPlayer():void
		{
			Player = new InterrogationCharacter();
			add(Player);
			Player.x = 16;
			Player.y = FP.height * 0.75;
			Player.SetBoundaries(0, FP.halfHeight + ProgressLine.height, FP.width, FP.height);
		}
		
		private function _createTimer():void
		{
			SpawnTimer = new Alarm(SpawnInterval, Spawn, Tween.LOOPING);
			addTween(SpawnTimer, true);
		}
		
		private function _createBar():void
		{
			ProgressBar = new ProgressBarEntity();
			add(ProgressBar);
			ProgressBar.x = 0;
			ProgressBar.y = ProgressLine.centerY - ProgressLine.halfHeight;
			ProgressBar.StartMovement();
			ProgressBar.OnReachedEnd = AlmostInnocent;
			
			ProgressBar.graphic.scrollX = 0;
			
			bringForward(ProgressBar);
		}
		
		private function _createLine():void
		{
			ProgressLine = new BaseEntity(0, 0, new Image(LINE_SPRITE));
			
			var g:Image = ProgressLine.graphic as Image;
			ProgressLine.setHitbox(g.width, g.height);
			
			add(ProgressLine);
			ProgressLine.x = 0;
			ProgressLine.y = FP.halfHeight;
			
			ProgressLine.graphic.scrollX = 0;
			
			sendBackward(ProgressLine);
		}
		
		public function Spawn():void
		{
			// reduce spawn timer every time.
			var p:BaseEntity;
			if (Math.random() > PowerupChance)
			{
				// var p:PoliceNoun = new PoliceNoun();
				p = new PoliceNoun();
			}
			else
			{
				// var pu:Powerup = new Powerup();
				p = new Powerup();
			}
			add(p);
			p.x = camera.x + FP.width + p.width;
			p.y = ProgressLine.y + ProgressLine.height + Math.random() * (FP.halfHeight - ProgressLine.height - p.height);
			sendToBack(p);
			
			SpawnInterval -= 0.05;
			SpawnTimer.reset(SpawnInterval);
			SpawnTimer.start()
			// trace("Reset spawn interval to " + SpawnInterval);
		}
		
		public function Hurt():void
		{
			ProgressBar.Bash();
		}
		
		public function Guilty():void
		{
			trace("Guilty called");
			Main.Perfect = false;
			Main.JuryOffset -= Math.min(ProgressBar.Hits, JuryEntity.Steps) // Detract from the jury by number of hits or a third of the jury steps, whichever is lower.
			this.FadeOut("Accused!", TrialCutscene);
		}
		
		public function AlmostInnocent():void
		{
			Main.JuryOffset += 2; // Being accused without basis gives your circumstantial benefits.
			// this.FadeOut("Dodged!", TrialWorld);
			FadeOut("Circumstantial evidence!", TrialCutscene);
		}
		
		public function OnPowerup(p:Powerup):void
		{
			if (p.Bad)
			{
				Hurt();
			}
			else
			{
				var toDestroy:Array = new Array();
				getClass(PoliceNoun, toDestroy);
				for each (var e:PoliceNoun in toDestroy)
				{
					e.Destroy();
				}
			}
		}
		
		override public function OnFadeIn():void 
		{
			super.OnFadeIn();
			Unpause();
		}
		
		override protected function setActiveState(s:Boolean):void 
		{
			super.setActiveState(s);
			
			var a:Array = new Array();
			getAll(a);
			for each (var e:Entity in a) e.active = s;
			
			Player.active = s;
			ProgressBar.active = s;
			SpawnTimer.active = s;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Frozen) return;
			
			camera.x++;
		}
	}
}