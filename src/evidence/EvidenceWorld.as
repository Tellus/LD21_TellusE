package  evidence
{
	import cutscenes.InterrogationCutscene;
	import dk.homestead.utils.Calc;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.Mask;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import police.InterrogationWorld;
	import trial.JuryEntity;
	
	/**
	 * Evidence world, first real interactive gameplay part.
	 * @author Johannes L. Borresen
	 */
	public class EvidenceWorld extends BaseWorld 
	{
		[Embed(source = '../../data/interrogation_intro.txt', mimeType = "application/octet-stream")] public static const ENDING_TEXT:Class;
		
		/**
		 * Number of bulidings to create.
		 */
		public const BUILDING_COUNT:int = 30;
		
		/**
		 * Starting number of police dudes.
		 */
		public const BASE_POLICE:int = 1;
		
		/**
		 * Number of loots that need dropping.
		 */
		public static const LOOT_COUNT:int = 20;
		
		/**
		 * Delay, in seconds, between each dude.
		 */
		public const SPAWN_DELAY:Number = 1;
		
		public var SpawnTimer:Alarm;
		
		public var Player:Character = new Character();
		
		// public var Buildings:BuildingSet;
		public var Buildings:Vector.<BuildingEntity> = new Vector.<BuildingEntity>();
		
		public var HidingSpots:Vector.<HidingSpotEntity> = new Vector.<HidingSpotEntity>();
		
		public var Caught:Boolean = false;
		
		/**
		 * Area for the proper gaming.
		 */
		public var PlayArea:BaseEntity;
		
		public var PlaySquare:int = 250;
		
		public var GUI:GuiLayer;
		
		public function EvidenceWorld() 
		{
			super();
			
			_createBg();
			_createSpawnTimer();
			_createPlayer();
			_createBuildings();
			_createPolice();
			_createGui();
			_createHelpText();
			
			trace("Checking entity count through constructor");
			_printB();
		}
		
		override public function begin():void 
		{
			super.begin();
			
			_placeBuildings();
			_placePlayer();
			_createHidingSpots();
			
			trace("Checking entity count through begin.");
			_printB();
			
			Pause();
		}
		
		private function _printB():void
		{
			var a:Array = new Array();
			getType("Building", a);
			trace("Building type is represented by " + a.length + " entities.");
		}
		
		private function _createBg():void
		{
			PlayArea = new BaseEntity();
			
			var g:Canvas = new Canvas(PlaySquare, PlaySquare);
			g.fill(new Rectangle(0, 0, g.width, g.height), 0xFF0000);
			
			PlayArea.graphic = g;
			PlayArea.setHitbox(PlaySquare, PlaySquare);
			
			add(PlayArea);
			
			PlayArea.Center = new Point(0, 0);
			
			PlayArea.visible = false;
		}
		
		private function _createHelpText():void
		{
			HelpEntity = new FlashTextEntity("Flee from the police\nand hide the loot!");
			HelpEntity.graphic.scrollX = HelpEntity.graphic.scrollY = 0;
		}
		
		private function _createSpawnTimer():void
		{
			SpawnTimer = new Alarm(SPAWN_DELAY, SpawnPolice, Tween.LOOPING);
			addTween(SpawnTimer, true);
		}
		
		private function _createGui():void
		{
			GUI = new GuiLayer();
			GUI.moveTo(0, FP.height - GUI.height);
			GUI.SetScroll(0, 0);
			add(GUI);
		}
		
		private function _createPolice():void
		{
			var p:Enemy;
			for (var i:int = 0; i < BASE_POLICE; i++)
			{
				p = new Enemy();
				add(p);
				p.Target = Player;
			}
		}
		
		private function _placePolice():void
		{
			var v:Vector.<Enemy> = new Vector.<Enemy>();
			getClass(Enemy, v);
			for each (var p:Enemy in v)
			{
				var pp:Point = GetPoliceSpawnPoint(p);
				p.x = pp.x;
				p.y = pp.y;
				p.Target = Player;
			}
		}
		
		private function _createBuildings():void
		{
			var b:BuildingEntity;
			for (var i:int = 0; i < BUILDING_COUNT; i++)
			{
				b = new BuildingEntity();
				b.x = -1000;
				b.y = -1000;
				add(b);
				Buildings.push(b);
			}
		}
		
		private function _placeBuildings():void
		{
			var v:Vector.<BuildingEntity> = new Vector.<BuildingEntity>();
			getClass(BuildingEntity, v);
			trace("Placing " + v.length + " buildings.");
			
			for each (var b:BuildingEntity in v)
			{
				b.moveTo(Math.random() * PlayArea.width * Calc.RandomSign(), Math.random() * PlayArea.height * Calc.RandomSign());
				
				var conf:Entity = b.collide("Building", b.x, b.y);
				
				while (conf != null)
				{
					trace("Collision. Fixing.");
					(conf as BuildingEntity).RelocateConflict(b);
					conf = b.collide("Building", b.x, b.y);
				}
			}
		}
		
		private function _createPlayer():void
		{
			add(Player);
		}
		
		private function _placePlayer():void
		{
			trace("Placing player among, building count:");
			_printB();
			var p:Point = GetSpawnPoint(Player);
			Player.x = p.x;
			Player.y = p.y;
		}
		
		private function _createHidingSpots():void
		{
			var l:HidingSpotEntity;
			var p:Point;
			var b:BuildingEntity;
			for (var i:int = 0; i < LOOT_COUNT; i++)
			{
				l = new HidingSpotEntity();
				add(l);
				p = Buildings[Math.floor(Math.random() * Buildings.length)].GetRandomEdgePoint();
				l.Center = p;
				while (l.collide("Building", l.x, l.y) != null)
				{
					p = Buildings[Math.floor(Math.random() * Buildings.length)].GetRandomEdgePoint();
					l.Center = p;
				}
			}
		}
		
		/**
		 * Retrieves a viable spawn point for a particular entity.
		 * @param	unit	The entity to find a spawn point for.
		 * @return	The new point.
		 */
		public function GetSpawnPoint(unit:Entity):Point
		{
			var p:Point = new Point(Math.random() * (PlayArea.width) * Calc.RandomSign(), Math.random() * (PlayArea.height) * Calc.RandomSign());
			while (unit.collide("Building", p.x, p.y) != null)
			{
				trace("Invalid spawn point for " + unit.toString() + ". Finding new one");
				p = new Point(Math.random() * (PlayArea.width) * Calc.RandomSign(), Math.random() * (PlayArea.height) * Calc.RandomSign());
			}
			return p;
		}
		
		public function GetPoliceSpawnPoint(unit:Entity):Point
		{
			var p:Point = new Point(Math.random() * (PlayArea.width) * Calc.RandomSign(), Math.random() * (PlayArea.height) * Calc.RandomSign());
			while (unit.collide("Building", p.x, p.y) != null ||
				  ((p.x > camera.x && p.x < camera.x + FP.width) &&
				  (p.y > camera.y && p.y < camera.y + FP.height)))
			{
				trace("Invalid spawn point for " + unit.toString() + ". Finding new one");
				p = new Point(Math.random() * (PlayArea.width) * Calc.RandomSign(), Math.random() * (PlayArea.height) * Calc.RandomSign());
			}
			return p;			
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Player.collide("Police", Player.x, Player.y) != null) OnCaught();
			
			camera.x = Player.x - FP.halfWidth;
			camera.y = Player.y - FP.halfHeight;
			
			if (Input.pressed(Key.H)) _printB();
		}
		
		public function OnLootDropped(spot:HidingSpotEntity):void
		{
			GUI.DropLoot();
			if (GUI.LootCount == 0)
			{
				Freeze();
				
				Main.JuryOffset += 2; // Two in favour if no loot could be found on your person.
				
				// FadeOut("You ditched the loot!", InterrogationWorld);
				FadeOut("You ditched the loot!", InterrogationCutscene);
			}
		}
		
		public function SpawnPolice():void
		{
			var p:Enemy = new Enemy();
			add(p);
			var pt:Point = GetPoliceSpawnPoint(p);
			p.x = pt.x;
			p.y = pt.y;
			p.Target = Player;
		}
		
		override protected function setActiveState(s:Boolean):void
		{
			trace("Setting active state to : " + s.toString());
			
			Player.active = s;
			
			var v:Vector.<Enemy> = new Vector.<Enemy>();
			getClass(Enemy, v);
			
			for each (var p:Enemy in v) p.active = s;
			
			SpawnTimer.active = s;
		}
		
		override public function OnFadeIn():void 
		{
			super.OnFadeIn();
			Unpause();
		}
		
		/**
		 * Called when the player is (finally) caught by the cops.
		 */
		public function OnCaught():void
		{
			if (!Caught)
			{
				Caught = true;
				
				Freeze();
				
				Main.JuryOffset -= Math.min(GUI.LootCount, JuryEntity.Steps / 3); // Add every piece of loot, at most a third of the necessary to be deemed guilty.
				
				Main.Perfect = false;
				
				FadeOut("You were caught!", InterrogationCutscene);
			}
		}
	}
}