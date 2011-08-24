package  
{
	import flash.utils.ByteArray;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * Intermediate world between worlds.
	 * @author ...
	 */
	public class CutsceneWorld extends BaseWorld 
	{
		// [Embed(source = '../snd/intro_music.mp3')] public static const CUTSCENE_MUSIC:Class;
		[Embed(source = '../snd/intro_music_low.mp3')] public static const CUTSCENE_MUSIC:Class;
		
		public var TextEntity:TextScroll;
		
		public var GoToWorld:Class;
		
		public var Voice:Sfx;
		
		public var Music:Sfx;
		
		public function CutsceneWorld(source:Class, speak:Class, nextWorld:Class) 
		{
			super();
			
			var bs:ByteArray = new source();
			
			_createText(source);
			
			GoToWorld = nextWorld;
			
			Music = new Sfx(CUTSCENE_MUSIC);
			Music.play(0.2);
						
			Voice = new Sfx(speak);
			Voice.play();
		}
		
		private function _createText(source:Class):void
		{
			TextEntity = new TextScroll(source, FP.width, FP.height);
			
			TextEntity.Padding = 15;
			
			add(TextEntity);
			
			TextEntity.Start();
		}
		
		override public function begin():void 
		{
			super.begin();
			bringToFront(TextEntity);
		}
		
		override public function OnFadeIn():void 
		{
			super.OnFadeIn();
			
			trace("Starting cutscene");
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
			{
				Voice.stop();
				Music.stop();
				FP.world = new GoToWorld();
			}
		}
	}
}