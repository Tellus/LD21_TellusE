package  trial
{
	import cutscenes.GameOverScene;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import trial.PlayerHand;
	
	/**
	 * The final world in the LD entry, the trial world places the player in front
	 * of the jury being grilled by a lawer.
	 * Throughout, the player must control his shaking hands, drying his brow before
	 * sweating too much and swallowing regularly.
	 * @author Johannes L. Borresen
	 */
	public class TrialWorld extends BaseWorld 
	{
		[Embed(source = '../../img/trial/face.png')] public static const PLAYER_FACE:Class;
		
		public var Jury:JuryEntity;
		
		public var Lawyer:LawyerEntity = new LawyerEntity(OnLawyer);
		
		public var Sweat:SweatEntity = new SweatEntity();
		
		public var Background:FutureEntity;
		
		public var PlayerMouth:Mouth;
		
		public function TrialWorld() 
		{
			super();
			
			_createBg();
			_createStatics();
			_createHand();
			_createHand2();
			_createMouth();
			_createLawyer();
			_createSweat();
			_createJury();
			
			_createHelpText();
			
			Pause();
			
			trace("Started trial with a jury rating of " + Main.JuryOffset);
		}
		
		private function _createHelpText():void
		{
			HelpEntity = new FlashTextEntity("Keep your hands steady\nand remember to swallow\n(Enter)\nto win over the jury!");
		}
		
		private function _createBg():void
		{
			Background = new FutureEntity();
			add(Background);
		}
		
		private function _createSweat():void
		{
			add(Sweat);
			Sweat.x = FP.halfWidth;
			Sweat.y = 50;
		}
		
		private function _createLawyer():void
		{
			add(Lawyer);
		}
		
		private function _createJury():void
		{
			Jury = new JuryEntity();
			add(Jury);
			Jury.OnGuilty = OnGuilty;
			Jury.OnInnocent = OnInnocent;
		}
		
		private function _createMouth():void
		{
			PlayerMouth = new Mouth();
			PlayerMouth.SetKey(Key.ENTER);
			add(PlayerMouth);
			PlayerMouth.x = FP.halfWidth - PlayerMouth.halfWidth;
			PlayerMouth.y = FP.halfHeight * 0.8;
		}
		
		private function _createHand():void
		{
			// var h:PlayerHand = new PlayerHand(FP.halfWidth / 2, FP.halfHeight);
			var h:PlayerHand = new PlayerHand(165, 325, PlayerHand.RIGHTY);
			h.SetKeys(Key.W, Key.S, Key.A, Key.D);
			bringForward(h);
			add(h);
		}
		
		private function _createHand2():void
		{
			// var h:PlayerHand = new PlayerHand(FP.halfWidth * 1.5, FP.halfHeight, PlayerHand.LEFTY);
			var h:PlayerHand = new PlayerHand(481, 325, PlayerHand.LEFTY);
			h.x -= h.width;
			// h.SetKeys(Key.W, Key.S, Key.A, Key.D);
			h.SetKeys(Key.UP, Key.DOWN, Key.LEFT, Key.RIGHT);
			bringForward(h);
			add(h);
		}
		
		private function _createStatics():void
		{
			var g:Image = new Image(PLAYER_FACE);
			g.scale = Main.GAME_SCALE;
			
			var e:BaseEntity = new BaseEntity();
			
			e.graphic = g;
			
			e.setHitbox(g.scaledWidth, g.scaledHeight);
			
			e.x = FP.halfWidth - e.halfWidth;
			e.y = 103;
			
			add(e);
			
			sendToBack(e);
		}
		
		public function OnGuilty():void
		{
			// FadeOut("You were found guilty!", TitleWorld);
			Main.Innocent = false;
			FadeOut("You were found guilty!", GameOverScene);
		}
		
		public function OnInnocent():void
		{
			Main.Innocent = true;
			FadeOut("You were found innocent!", GameOverScene);
		}
		
		public function OnLawyer():void
		{
			// Make jury changes depending on current hand, mouth and brow status.
			trace("Jury is asserting you.");
			var a:Array = new Array();
			getClass(PlayerHand, a);
			for each (var h:PlayerHand in a)
			{
				if (h.CheckSteady())
				{
					trace("One hand is steady. Jury believes you.");
					Jury.Absolve();
				}
				else
				{
					trace("One hand is unsteady. The jury doubts you.");
					Jury.Condemn();
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
			Jury.active = s;
			Lawyer.active = s;
			PlayerMouth.active = s;
			
			var a:Array = new Array();
			getClass(PlayerHand, a);
			for each (var h:PlayerHand in a) h.active = s;
		}
		
		override public function update():void 
		{
			super.update();
		}
	}

}