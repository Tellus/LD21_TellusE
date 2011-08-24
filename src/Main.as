package 
{
	import cutscenes.GameOverScene;
	import dk.homestead.flashpunk.groups.CellEntityGroup;
	import evidence.EvidenceWorld;
	import flash.display.Sprite;
	import flash.events.Event;
	import intro.IntroWorld;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import police.InterrogationWorld;
	import trial.TrialWorld;
	
	/**
	 * Main stuff!
	 * @author Johannes L. Borresen
	 */
	// [Frame(factoryClass="Preloader")]
	public class Main extends Engine 
	{
		/**
		 * Global scaling number, since most of the items are scaled up to four times.
		 */
		public static const GAME_SCALE:int = 4;
		
		/**
		 * Initially you go perfect :D
		 */
		public static var Perfect:Boolean = true;

		// Final game outcome.
		public static var Innocent:Boolean = true;
		
		/**
		 * Initial jury offset at the start of the trial. Worlds can pitch in and shift this around according
		 * to their results.
		 */
		public static var _juryOffset:int = 0;
		
		public static function get JuryOffset():int
		{
			return _juryOffset;
		}
		
		public static function set JuryOffset(value:int):void
		{
			trace("Jury's offset changed to " + value.toString())
			_juryOffset = value;
		}
		
		public function Main():void 
		{
			super(640, 480, 60, false);
		}
		
		override public function init():void 
		{
			super.init();
			
			// FP.console.enable();
			FP.console.toggleKey = Key.NUMPAD_MULTIPLY;
			_createBaseInputs();
			
			FP.world = new FlashPunkWorld();
			// FP.world = new IntroWorld();
			// FP.world = new EvidenceWorld()
			// FP.world = new InterrogationWorld();
			// FP.world = new TrialWorld();
		}
		
		override public function update():void 
		{
			super.update();
			if (Input.pressed("CONSOLE")) FP.console.enable();
		}
		
		private function _createBaseInputs():void
		{
			trace("Base inputs created.");
			Input.define("LEFT", Key.A, Key.LEFT);
			Input.define("RIGHT", Key.D, Key.RIGHT);
			Input.define("UP", Key.W, Key.UP);
			Input.define("DOWN", Key.S, Key.DOWN);
			Input.define("CONSOLE", Key.C);
		}
	}
}